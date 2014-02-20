//
//  SKWorkNewsController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKWorkNewsController.h"
#import "SKTableViewCell.h"
#import "SKSearchController.h"
#import "SKAttachViewController.h"
@interface SKWorkNewsController ()
{
}
@end

@implementation SKWorkNewsController
-(void)onRefrshClick
{
    [super onRefrshClick];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedWorkNews] delegate:self];
}

-(void)onSearchClick
{
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"searchnavcontroller"];
    SKSearchController* searcher = (SKSearchController*)[nav topViewController];
    searcher.doctype = SKWorkNews;
    [[APPUtils visibleViewController] presentViewController:nav animated:YES completion:^{
        
    }];
}


-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    [super dataFromDataBaseWithComleteBlock:block];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select  (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',w.crtm)) then 1 else 0 end ) as bz,w.TID,w.TPID,strftime('%%Y-%%m-%%d %%H:%%M',w.CRTM) CRTM,w.FID,w.ATTS,w.READED,w.AUNAME,w.TITL,w.OWUID,t.TID TPID \
                         from T_WORKNEWS w left join T_WORKNEWSTP t\
                         on w.TPID = t.TID\
                         where w.ENABLED = 1\
                         ORDER BY CRTM DESC;"];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSMutableDictionary* d in dataArray)
        {
            if (![[d objectForKey:@"bz"] intValue] && ![[d objectForKey:@"READED"] intValue]) {
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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(void)initData
{
    _sectionArray =
    [[NSArray alloc] initWithObjects:@"信息安全",@"战略信息择要",@"工作要情",@"法律法规",@"其它工作动态",@"经济运行通报",@"领导讲话",nil];
    _sectionDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self.tableView setHeaderOnly:YES];
    [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
        [_sectionDictionary addEntriesFromDictionary:[self praseWorkNewsArray:array]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
    
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section{
    if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0)
    {
        return [_sectionArray objectAtIndex:section];
    }else{
        return nil;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"worknewscell";
    SKTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
    NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
    NSDictionary* dataDictionary = [sectionArray objectAtIndex:indexPath.row];
    [cell setCMSInfo:dataDictionary];
    [cell resizeCellHeight];
    return cell;
}


-(CGFloat)cellHeight:(NSString*)cellTitle
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.];
    // 计算出长宽
    CGSize size = [cellTitle sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat height = size.height+35;
    // 返回需要的高度
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];
    NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];
    NSDictionary* dataDictionary = [sectionArray objectAtIndex:indexPath.row];
    return [self cellHeight:[dataDictionary objectForKey:@"TITL"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"notifyDetail"]) {
        SKAttachViewController *attachController = (SKAttachViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSString* sectionName  = [_sectionArray objectAtIndex:selectedIndexPath.section];
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];
        NSMutableDictionary* dataDict = sectionArray[selectedIndexPath.row];
        attachController.cmsInfo = dataDict;
        attachController.doctype = SKWorkNews;
        
        if (![[dataDict objectForKey:@"READED"] intValue])
        {
            NSString* sql =[NSString stringWithFormat:@"update T_WORKNEWS set READED = 1 where TID = '%@';",[dataDict objectForKey:@"TID"]];
            [dataDict setObject:@"1" forKey:@"READED"];
            [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
            });
        }
        
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"notifyDetail" sender:self];
}

@end
