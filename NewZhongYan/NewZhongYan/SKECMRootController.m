//
//  SKECMRootController.m
//  NewZhongYan
//
//  Created by lilin on 13-12-26.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKECMRootController.h"
#import "SKTableViewCell.h"
#import "SKToolBar.h"
#import "SKDaemonManager.h"
#import "SKBrowseNewsController.h"
#import "SKECMBrowseController.h"
#define UP 1
#define DOWN 0
#define READ 1
#define UNREAD 0
#define BEFORETWODAY 1 //两天以前
#define INNERTWODAY  0 //两天以内

@interface SKECMRootController ()
{
    NSMutableArray              *_dataItems;
    NSArray* subChannels;
    NSInteger                   currentIndex;
    __weak IBOutlet UIButton *titleButton;
}
@end

@implementation SKECMRootController
-(void)onRefrshClick
{
    [SKDaemonManager SynDocumentsWithChannel:self.channel complete:^{
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView tableViewDidFinishedLoading];
                [self.tableView reloadData];
                [BWStatusBarOverlay showSuccessWithMessage:@"同步新闻完成" duration:1 animated:1];
            });

        }];
    } faliure:^(NSError* error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView tableViewDidFinishedLoading];
        });
        NSLog(@"SKDaemonManager = %@",[error userInfo][@"reason"]);
    } Type:UP];
}

-(void)dataFromDataBaseWithFid:(NSString*)currentFid  ComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,AID,TITL, ATTRLABLE,PMS,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",currentFid];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSMutableDictionary* d in dataArray)
        {
            if ([[d objectForKey:@"bz"] intValue] == INNERTWODAY && [[d objectForKey:@"READED"] intValue] == UNREAD) {
                [d setObject:@"0" forKey:@"READED"];
            }else{
                [d setObject:@"1" forKey:@"READED"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}


#pragma mark -Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)anIndex
{
    if (currentIndex == anIndex || anIndex == subChannels.count) {
        return;
    }
    [_dataItems removeAllObjects];
    [self dataFromDataBaseWithFid:subChannels[anIndex][@"FIDLIST"] ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        [self.tableView reloadData];
    }];
    currentIndex = anIndex;
    [actionSheet setDelegate:nil];
}


- (IBAction)selectType:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.channel.NAME
                                                             delegate:self
                                                    cancelButtonTitle:0
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:0,nil];
    for (NSDictionary* dict in subChannels) {
        [actionSheet addButtonWithTitle:dict[@"NAME"]];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet setCancelButtonIndex:subChannels.count];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)initToolView
{
    SKToolBar* myToolBar = [[SKToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)  FirstTarget:self FirstAction:@selector(onSearchClick)
                                               SecondTarget:self.tableView SecondAction:@selector(launchRefreshing)];
    [toolView addSubview:myToolBar];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initData
{
    self.title = self.channel.NAME;
    if (self.channel.HASSUBTYPE) {
        NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL WHERE PARENTID  = %@",self.channel.CURRENTID];
        subChannels = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];  NSString* fidlist = [NSString string];
        for (NSDictionary* dict in subChannels) {
            fidlist = [fidlist stringByAppendingFormat:@",%@",dict[@"FIDLIST"]];
        }
        fidlist = [fidlist substringFromIndex:1];
        self.channel.FIDLIST = fidlist;
    }else{
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 21)];
        label.text = self.channel.NAME;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
    }
  
    [titleButton setHidden:!self.channel.HASSUBTYPE];
    [self dataFromDataBaseWithFid:self.channel.FIDLIST ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        [self.tableView tableViewDidFinishedLoading];
        //[self.tableView setReachedTheEnd:array.count < 20];
        [self.tableView reloadData];
        [self onRefrshClick];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initToolView];
}


-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,AID,PAPERID,TITL,ATTRLABLE,PMS,URL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",self.channel.FIDLIST];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSMutableDictionary* d in dataArray)
        {
            if ([[d objectForKey:@"bz"] intValue] == INNERTWODAY && [[d objectForKey:@"READED"] intValue] == UNREAD) {
                [d setObject:@"0" forKey:@"READED"];
            }else{
                [d setObject:@"1" forKey:@"READED"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != (UIScrollView*)self.tableView) return;
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != (UIScrollView*)self.tableView)   return;
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(onRefrshClick) withObject:nil afterDelay:0.0];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self.tableView tableViewDidFinishedLoading];
//    [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
//        [_dataItems addObjectsFromArray:array];
//        [self.tableView tableViewDidFinishedLoading];
//        [self.tableView setReachedTheEnd:array.count < 20];
//        [self.tableView reloadData];
//    }];
}

#pragma mark - Table view data source/Users/lilin/Desktop/基于 ios7 的新工程/NewZhongYan/NewZhongYan/SKNewsAttachController.m


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataItems.count;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([self.channel.CODE isEqualToString:@"conews"]) {
//        return @"新闻列表";
//    }else if([self.channel.CODE isEqualToString:@"conotification"]){
//        return @"通知列表";
//    }
//    return @"新闻列表";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *CellIdentifier = @"CMSCell";
    //    SKTableViewCell *cell;
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
    //        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //    }else {
    //        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    }
    //    [cell setDataDictionary:[_dataItems objectAtIndex:indexPath.row]];
    //    return cell;
    
    static NSString* identify = @"newscell";
    SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell setECMInfo:_dataItems[indexPath.row]];
    [cell resizeCellHeight];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"news"]) {
//        SKNewsAttachController *attachController = (SKNewsAttachController *)[segue destinationViewController];
//        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//        attachController.news = _dataItems[selectedIndexPath.row];
    }
    if ([[segue identifier] isEqualToString:@"browse"]) {
        SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
        browser.channel = self.channel;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary* dict = _dataItems[selectedIndexPath.row];
        browser.currentDictionary = dict;
        if (![[dict objectForKey:@"READED"] intValue])
        {
            NSString* sql =[NSString stringWithFormat:@"update T_NEWS set READED = 1 where TID  = '%@'",[_dataItems[selectedIndexPath.row] objectForKey:@"TID"]];
            [dict setObject:@"1" forKey:@"READED"];
            [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
            });
        }
        [_tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"browse" sender:self];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [_dataItems[indexPath.row][@"TITL"]  sizeWithFont:font constrainedToSize:CGSizeMake(270, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 30;
}

@end
