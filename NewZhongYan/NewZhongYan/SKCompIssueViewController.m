//
//  SKCompIssueViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCompIssueViewController.h"
#import "SKTableViewCell.h"
#import "SKSearchController.h"
#import "SKAttachViewController.h"
@interface SKCompIssueViewController ()
{
    NSInteger                   currentIndex;
    NSString                    *currentCodocTpid;
}
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

@implementation SKCompIssueViewController

-(void)handleTapForHelpImage:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        UIImageView* helpImage = (UIImageView*)[self.view.window viewWithTag:1111];
        [helpImage fallOut:.4 delegate:nil completeBlock:^{
            [helpImage performSelector:@selector(removeFromSuperview) withObject:0 afterDelay:0.4];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }] ;
    }
}

- (IBAction)help:(id)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_help_company" : @"iphone4_help_company"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

-(void)onRefrshClick
{
    [super onRefrshClick];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedCompanyDocuments] delegate:self];
}

-(void)onSearchClick
{
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"searchnavcontroller"];
    SKSearchController* searcher = (SKSearchController*)[nav topViewController];
    searcher.doctype = SKNotify;
    [[APPUtils visibleViewController] presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)selectType:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"公文"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"全部",@"公司发文",@"办公室发文",@"党组织发文",@"收文",@"签呈",@"部门发函",@"其他",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark -Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)anIndex
{
    if (currentIndex == anIndex) {
        return;
    }
    switch (anIndex) {
        case 0:
        {
            [_titleButton setTitle:@"全部" forState:UIControlStateNormal];
            currentCodocTpid = @"";
            break;
        }
        case 1:
        {
            [_titleButton setTitle:@"公司发文" forState:UIControlStateNormal];
            currentCodocTpid = @"90";
            break;
        }
        case 2:
        {
            [_titleButton setTitle:@"办公室发文" forState:UIControlStateNormal];
            currentCodocTpid = @"91";
            break;
        }
        case 3:
        {
            [_titleButton setTitle:@"党组织发文" forState:UIControlStateNormal];
            currentCodocTpid = @"92";
            break;
        }
        case 4:
        {
            [_titleButton setTitle:@"收文" forState:UIControlStateNormal];
            currentCodocTpid = @"31";
            break;
        }
        case 5:
        {
            [_titleButton setTitle:@"签呈" forState:UIControlStateNormal];
            currentCodocTpid = @"32";
            break;
        }
        case 6:
        {
            [_titleButton setTitle:@"部门发函" forState:UIControlStateNormal];
            currentCodocTpid = @"33";
            break;
        }
        case 7:
        {
            [_titleButton setTitle:@"其他" forState:UIControlStateNormal];
            currentCodocTpid = @"34";
            break;
        }
        default:
            break;
    }
    [_dataItems removeAllObjects];
    [self dataFromDataBaseWithTid:currentCodocTpid ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        [self.tableView reloadData];
    }];
    currentIndex = anIndex;
    [actionSheet setDelegate:nil];
}

-(void)dataFromDataBaseWithTid:(NSString*)currentTpid  ComleteBlock:(resultsetBlock)block
{
    [super dataFromDataBaseWithComleteBlock:block];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql;
        if (currentTpid.length) {
            sql = [NSString stringWithFormat:
                   @"select  (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,ATTS,READED,AUNAME,TITL from T_CODOCS where ENABLED = 1 AND TPID = %@ ORDER BY CRTM DESC;",currentTpid];
        }else{
            sql = [NSString stringWithFormat:
                   @"select  (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,ATTS,READED,AUNAME,TITL from T_CODOCS where ENABLED = 1 ORDER BY CRTM DESC;"];
        }
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


-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    [super dataFromDataBaseWithComleteBlock:block];
    [self dataFromDataBaseWithTid:currentCodocTpid ComleteBlock:block];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initData
{
    currentCodocTpid = @"";
    self.title = @"公司公文";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(codocStateChanged:)
                                                 name:@"cocosStateChanged"
                                               object:0];
	[self.tableView setHeaderOnly:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self dataFromDataBaseWithTid:currentCodocTpid ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        [self.tableView reloadData];
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
    [self dataFromDataBaseWithTid:currentCodocTpid ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        [self.tableView tableViewDidFinishedLoading];
        [self.tableView reloadData];
    }];
}

#pragma mark - View TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataItems.count ;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section{
	return [_titleButton titleForState:UIControlStateNormal];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"codocscell";
    SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell setCMSInfo:[_dataItems objectAtIndex:indexPath.row]];
    [cell resizeCellHeight];
    return cell;
}

-(CGFloat)cellHeight:(NSString*)cellTitle
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont systemFontOfSize:16];
    // 计算出长宽
    CGSize size = [cellTitle sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat height = size.height+35;
    // 返回需要的高度
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dataDictionary = [_dataItems objectAtIndex:indexPath.row];
    
    return [self cellHeight:[dataDictionary objectForKey:@"TITL"]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"notifyDetail"]) {
        SKAttachViewController *attachController = (SKAttachViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary* dataDict = _dataItems[selectedIndexPath.row];
        attachController.cmsInfo = dataDict;
        attachController.doctype = SKCodocs;
        
        if (![[dataDict objectForKey:@"READED"] intValue])
        {
            NSString* sql =[NSString stringWithFormat:@"update T_CODOCS set READED = 1 where TID = '%@';",[dataDict objectForKey:@"TID"]];
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
