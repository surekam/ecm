//
//  SKMaintainViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMaintainViewController.h"
#import "SKToolBar.h"
#import "EmailHelper.h"
#import "OAHelper.h"
#import "NewsHelper.h"
#import "NotifyHelper.h"
#import "AnnounceHelper.h"
#import "MeetingHelper.h"
#import "WorkNewsHelper.h"
#import "CODOCSHelper.h"

#import "SKAppMaintainCell.h"
@interface SKMaintainViewController ()
{
    UIActivityIndicatorView *indicator;
    NSMutableArray *dataArray;
    int currentTag;
    BOOL isClearAll;
    long long filesize;
}
@end

@implementation SKMaintainViewController

-(void)reload
{
    [dataArray removeAllObjects];
    NSDictionary *newsDic=[NSDictionary dictionaryWithObjectsAndKeys:
                           [UIImage imageNamed:@"icon_news.png"],@"image",@"新闻",@"title",[NewsHelper getSize],@"size",nil];
    NSDictionary *emailDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            [UIImage imageNamed:@"icon_email.png"],@"image",@"邮件",@"title",[EmailHelper getSize],@"size",nil];
    NSDictionary *oaDic=[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIImage imageNamed:@"icon_gtasks.png"],@"image",@"统一待办",@"title",[OAHelper getSize],@"size",nil];
    NSDictionary *notifyDic=[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIImage imageNamed:@"icon_notice.png"],@"image",@"通知",@"title",[NotifyHelper getSize],@"size",nil];
    NSDictionary *announceDic=[NSDictionary dictionaryWithObjectsAndKeys:
                               [UIImage imageNamed:@"icon_announcement.png"],@"image",@"公告",@"title",[AnnounceHelper getSize],@"size",nil];
    NSDictionary *workNewsDic=[NSDictionary dictionaryWithObjectsAndKeys:
                               [UIImage imageNamed:@"icon_touchstone.png"],@"image",@"公司动态",@"title",[WorkNewsHelper getSize],@"size",nil];
    NSDictionary *meetingDic=[NSDictionary dictionaryWithObjectsAndKeys:
                              [UIImage imageNamed:@"icon_meeting.png"],@"image",@"会议",@"title",[MeetingHelper getSize],@"size",nil];
    NSDictionary *codocsDic=[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIImage imageNamed:@"icon_companydocuments.png"],@"image",@"公司公文",@"title",[CODOCSHelper getSize],@"size",nil];
    [dataArray addObject:oaDic];
    [dataArray addObject:emailDic];
    [dataArray addObject:newsDic];
    [dataArray addObject:notifyDic];
    [dataArray addObject:announceDic];
    [dataArray addObject:meetingDic];
    [dataArray addObject:workNewsDic];
    [dataArray addObject:codocsDic];
    [tableview reloadData];
}

-(void)showAlert:(BOOL)needClean
{
    if (needClean) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本次清理后系统仍然会为您保存最近的数据，确定清理吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"系统保存的是最近的数据，无需清理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)cleanData:(NSNotification *)note
{
    //首先判断是否需要清理 如果需要清理 加入询问是否清理
    int index=[[note.userInfo objectForKey:@"tag"] intValue];
    currentTag=index;
    isClearAll=NO;
    switch (index) {
        case 0:
            [self showAlert:[OAHelper needClean]];
            break;
        case 1:
            [self showAlert:[EmailHelper needClean]];
            break;
        case 2:
            [self showAlert:[NewsHelper needClean]];
            break;
        case 3:
            [self showAlert:[NotifyHelper needClean]];
            break;
        case 4:
            [self showAlert:[AnnounceHelper needClean]];
            break;
        case 5:
            [self showAlert:[MeetingHelper needClean]];
            break;
        case 6:
            [self showAlert:[WorkNewsHelper needClean]];
            break;
        case 7:
            [self showAlert:[CODOCSHelper needClean]];
            break;
        default:
            break;
    }
}

-(void)cleanAll
{
    if (![OAHelper needClean]&&![EmailHelper needClean]&&![NotifyHelper needClean]&&![AnnounceHelper needClean]&&![MeetingHelper needClean]&&![WorkNewsHelper needClean]&&![NewsHelper needClean]&&![CODOCSHelper needClean])
    {        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"系统保存的是最近的数据，无需清理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        isClearAll=YES;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本次清理后系统仍然会为您保存最近的数据，确定要清理吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (isClearAll)
        {
            [OAHelper cleanLocalData];
            [EmailHelper cleanLocalData];
            [NotifyHelper cleanLocalData];
            [AnnounceHelper cleanLocalData];
            [MeetingHelper cleanLocalData];
            [WorkNewsHelper cleanLocalData];
            [NewsHelper cleanLocalData];
            [CODOCSHelper cleanLocalData];
        }
        else
        {
            switch (currentTag)
            {
                case 0:
                    [OAHelper cleanLocalData];
                    break;
                case 1:
                    [EmailHelper cleanLocalData];
                    break;
                case 2:
                    [NewsHelper cleanLocalData];
                    break;
                case 3:
                    [NotifyHelper cleanLocalData];
                    break;
                case 4:
                    [AnnounceHelper cleanLocalData];
                    break;
                case 5:
                    [MeetingHelper cleanLocalData];
                    break;
                case 6:
                    [WorkNewsHelper cleanLocalData];
                    break;
                case 7:
                    [CODOCSHelper cleanLocalData];
                    break;
                default:
                    break;
            }
        }
        [self showIndicator];
    }
}

-(void)hideIndicator
{
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [self reload];
}

-(void)showIndicator
{
    [indicator setHidden:NO];
    [indicator startAnimating];
    [self performSelector:@selector(hideIndicator) withObject:nil afterDelay:1.5];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanData:) name:@"cleanLocalDataNote" object:nil];
    dataArray=[[NSMutableArray alloc] init];
    NSString *basicPath=[[FileUtils documentPath] stringByAppendingPathComponent:@"zhongYan.db"];
    NSString* size = [[[NSFileManager defaultManager] attributesOfItemAtPath:basicPath error:0] objectForKey:@"NSFileSize"];
    filesize = size.longLongValue;
    
    CGRect toolRect = CGRectMake(0,0, 320, 49);
    SKToolBar* myToolBar = [[SKToolBar alloc] initMaintainWithFrame:toolRect Target:self Action:@selector(cleanAll)];
    [toolView addSubview:myToolBar];
    
    indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setCenter:CGPointMake(160, (ScreenHeight/2))];
    [indicator setColor:[UIColor darkGrayColor]];
    [self.view addSubview:indicator];
    [indicator setHidden:YES];
    [self reload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contentCell";
    static NSString *indexIdentifier = @"indexCell";
    static NSString *summaryIdentifier = @"summaryCell";
    SKAppMaintainCell *cell;
    if (indexPath.row == 0) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:indexIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:indexIdentifier];
        }
    }else if (indexPath.row == dataArray.count + 1){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:summaryIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:summaryIdentifier];
        }
        UILabel* sizeLabel = (UILabel*)[cell.contentView viewWithTag:101];
        [sizeLabel setText:[FileUtils formattedFileSize:filesize]];
    }else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.tag = indexPath.row - 1;
        [cell setDataInfo:dataArray[indexPath.row - 1]];
    }
    return cell;
}
@end
