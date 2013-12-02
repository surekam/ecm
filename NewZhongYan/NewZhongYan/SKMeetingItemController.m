//
//  SKMeetingItemController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMeetingItemController.h"
#import "SKCMeetCell.h"
#import "SKSearchController.h"
#import "SKAttachViewController.h"
@interface SKMeetingItemController ()
{

}
@end

@implementation SKMeetingItemController
-(void)onRefrshClick
{
    [super onRefrshClick];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedMeeting] delegate:self];
}

-(void)onSearchClick
{
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"searchnavcontroller"];
    SKSearchController* searcher = (SKSearchController*)[nav topViewController];
    searcher.doctype = SKNotify;
    [[APPUtils visibleViewController] presentViewController:nav animated:YES completion:^{
        
    }];
}

-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    [super dataFromDataBaseWithComleteBlock:block];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [NSString stringWithFormat:
                         @"SELECT  (case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as bz,TID,ATTS,TITL,CRTM,AUNAME,strftime('%%Y-%%m-%%d %%H:%%M',BGTM) BGTM,strftime('%%Y-%%m-%%d %%H:%%M',EDTM) EDTM FROM T_NOTIFY WHERE TPID = '31' AND ENABLED = 1 ORDER BY BGTM DESC LIMIT %d,%d",from,20];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}


-(void)initData
{
    _sectionArray = [[NSArray alloc] initWithObjects:@"即将召开&正在召开",@"已召开", nil];
    _sectionDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
        [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView setReachedTheEnd:array.count < 20];
        [self.tableView reloadData];
        from += 20;
    }];
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
    [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
        [_dataItems addObjectsFromArray:array];
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView setReachedTheEnd:array.count < 20];
        [self.tableView reloadData];
        from += 20;
    }];
}

#pragma mark - View TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionDictionary count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
        return [_sectionArray objectAtIndex:section];
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return cell;}


-(CGFloat)meetCellHeight:(NSString*)cellTitle
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font =  [UIFont fontWithName:@"Helvetica" size:16.];
    // 计算出长宽
    CGSize size = [cellTitle sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat height = size.height+55;
    // 返回需要的高度
    return height;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataDictionary;
    NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
    NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
    dataDictionary = [sectionArray objectAtIndex:indexPath.row];
    
    
    return [self meetCellHeight:[dataDictionary objectForKey:@"TITL"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"notifyDetail"]) {
        SKAttachViewController *attachController = (SKAttachViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSString* sectionName  = [_sectionArray objectAtIndex:selectedIndexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        attachController.cmsInfo = sectionArray[selectedIndexPath.row];
        attachController.doctype = SKMeet;
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"notifyDetail" sender:self];
}
@end
