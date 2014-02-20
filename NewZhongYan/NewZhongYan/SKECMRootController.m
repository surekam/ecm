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
#import "SKSearchController.h"
#import "SKECMSearchController.h"
#import "SKCMeetCell.h"
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
    UIButton *titleButton;
}
@end

@implementation SKECMRootController
-(void)onSearchClick
{
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"ecmsearchnavcontroller"];
    SKECMSearchController* searcher = (SKECMSearchController*)[nav topViewController];
    searcher.fidlist = self.channel.FIDLIST;
    searcher.isMeeting = isMeeting;
    [[APPUtils visibleViewController] presentViewController:nav animated:YES completion:^{
        
    }];
    //[self performSegueWithIdentifier:@"ecmsearch" sender:self];
}

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
    } Type:UP];
}

-(void)dataFromDataBaseWithFid:(NSString*)currentFid  ComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,(case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as az,AID,PAPERID,TITL,ATTRLABLE,PMS,URL,ADDITION,BGTM,EDTM,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",currentFid];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        //NSLog(@"%@",dataArray);
        if (isMeeting) {
            NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               [NSMutableArray array],@"即将召开&正在召开",
                                               [NSMutableArray array],@"已召开", nil];
            
            for (NSDictionary *dict in [NSArray arrayWithArray:dataArray]){
                NSString* bz = [dict objectForKey:@"az"];
                if (bz.intValue) {
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"即将召开&正在召开"] addObject:dict];
                }else{
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"已召开"]  addObject:dict];
                }
            }
            _sectionDictionary = [NSMutableDictionary dictionaryWithDictionary:sectionDictionary];
        }else{
            for (NSMutableDictionary* d in dataArray)
            {
                if ([[d objectForKey:@"bz"] intValue] == INNERTWODAY && [[d objectForKey:@"READED"] intValue] == UNREAD) {
                    [d setObject:@"0" forKey:@"READED"];
                }else{
                    [d setObject:@"1" forKey:@"READED"];
                }
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

-(NSDictionary*)praseMeetingArray:(NSArray*)meetings{
    NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSMutableArray array],@"即将召开&正在召开",
                                       [NSMutableArray array],@"已召开", nil];
    
    for (NSDictionary *dict in [NSArray arrayWithArray:meetings]){
        NSString* bz = [dict objectForKey:@"az"];
        if (bz.intValue) {
            [(NSMutableArray*)[sectionDictionary objectForKey:@"即将召开&正在召开"] addObject:dict];
        }else{
            [(NSMutableArray*)[sectionDictionary objectForKey:@"已召开"]  addObject:dict];
        }
    }
    return sectionDictionary;
}

-(void)initData
{
    self.title = self.channel.NAME;
    isMeeting = [self.channel.TYPELABLE isEqualToString:@"meeting,"];
    [titleButton setHidden:!self.channel.HASSUBTYPE];
    
    //这里做了一个FIDLIST的拼接
    if (self.channel.HASSUBTYPE) {
        //documentId = self.channel.FIDLISTS;
        [titleButton setHidden:NO];
        NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL WHERE PARENTID  = %@",self.channel.CURRENTID];
        subChannels = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    }else{
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 21)];
        label.text = self.channel.NAME;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        [titleButton setHidden:YES];
        //documentId = self.channel.FIDLIST;
    }

    
    if (isMeeting) {
        _sectionArray = [[NSArray alloc] initWithObjects:@"即将召开&正在召开",@"已召开", nil];
        _sectionDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [self dataFromDataBaseWithFid:self.channel.FIDLISTS ComleteBlock:^(NSArray* array){
        if (isMeeting) {
            [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
        } else {
            [_dataItems setArray:array];
        }
        [self.tableView tableViewDidFinishedLoading];
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
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,(case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as az,AID,PAPERID,TITL,ATTRLABLE,PMS,URL,ADDITION,BGTM,EDTM,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",self.channel.FIDLISTS];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isMeeting) {
        return [_sectionDictionary count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isMeeting) {
        return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
    } else {
        return _dataItems.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isMeeting) {
        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
            return [_sectionArray objectAtIndex:section];
        }else{
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMeeting) {
        static NSString* identify = @"meetcell";
        SKCMeetCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKCMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        NSDictionary*dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        
        [cell setCMSInfo:dataDictionary Section:indexPath.section];
        [cell resizeCellHeight];
        return cell;

    }else{
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"browse"]) {
        if (isMeeting) {
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSString* sectionName  = [_sectionArray objectAtIndex:selectedIndexPath.section];//获取section 的名字
            NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
            SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
            browser.channel = self.channel;
            browser.currentDictionary = sectionArray[selectedIndexPath.row];;
        }else{
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSMutableDictionary* dict = _dataItems[selectedIndexPath.row];
            SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
            browser.channel = self.channel;
            browser.currentDictionary = dict;
            if (![[dict objectForKey:@"READED"] intValue])
            {
                NSString* sql =[NSString stringWithFormat:@"update T_DOCUMENTS set READED = 1 where AID  = '%@'",[_dataItems[selectedIndexPath.row] objectForKey:@"AID"]];
                [dict setObject:@"1" forKey:@"READED"];
                [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
                });
            }
            [_tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"browse" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMeeting) {
        NSDictionary* dataDictionary;
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        CGFloat contentWidth = 280;
        UIFont *font =  [UIFont fontWithName:@"Helvetica" size:16.];
        CGSize size = [dataDictionary[@"TITL"] sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat height = size.height+55;
        return height;
    }else{
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = [_dataItems[indexPath.row][@"TITL"]  sizeWithFont:font constrainedToSize:CGSizeMake(270, 220) lineBreakMode:NSLineBreakByTruncatingTail];
        return size.height + 30;
    }
}
@end
