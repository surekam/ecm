//
//  SKViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKViewController.h"
#import "SKLoginViewController.h"
#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLElement.h"
#import "SKSystemMenuController.h"
#import "SKPatternLockController.h"
#import "SKAgentLogonManager.h"
#import "LocalMetaDataManager.h"
#import "GetNewVersion.h"
#import "SKAPPUpdateController.h"
#import "MBProgressHUD.h"
#import "DataServiceURLs.h"
#import "SKGridController.h"
#import "UIView+screenshot.h"
#import "UIImage+BlurredFrame.h"
#define OriginY ((IS_IOS7) ? 64 : 0 )
@interface SKViewController ()
{
    SKSystemMenuController* settingController;
    BWStatusBarOverlay* BWStatusBar;
    //UIPageControl* pageController;
    
    __weak IBOutlet UIView *workItemView;
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIImageView *titleImageView;
    __weak IBOutlet UILabel *titleLabel;
    UIView* topView;
    
    SKGridController* companyController;
    SKGridController* selfCompanyController;
    NSMutableArray* controllerArray;
}
@end

@implementation SKViewController
@synthesize bgScrollView;
@synthesize pageController;
-(UIStatusBarStyle)preferredStatusBarStyle
{
   // return UIStatusBarStyleDefault;
    return UIStatusBarStyleLightContent;
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return  UIBarPositionTop;
}

//功能:点击帮助界面消失的手势
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

- (IBAction)onHelpButtonClick:(id)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_mainpage" : @"iphone4_mainpage"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

//功能:将用于界面布局的xml文件拷贝到document文件夹中 因为位于bundle中的xml文件不能修改他
-(void)copyXMLToDocument
{
    //这里最好判断原xml文件是不是存在 在向doc中执行复制操作
    NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"main_config"ofType:@"xml"]];
    NSString *docPath=[[FileUtils documentPath] stringByAppendingPathComponent:@"main_config.xml"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:docPath error:nil];
    }else{
        [[NSFileManager defaultManager] removeItemAtPath:docPath error:0];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:docPath error:nil];
    }
}

-(void)initNavBar
{
    self.navigationItem.backBarButtonItem.title = @"返回";
    UIImage* navbgImage;
    if (System_Version_Small_Than_(7)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        navbgImage = [UIImage imageNamed:@"navbar44"] ;
        self.navigationController.navigationBar.tintColor = COLOR(0, 97, 194);
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
        navbgImage = [UIImage imageNamed:@"navbar64"] ;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    }
    [self.navigationController.navigationBar setBackgroundImage:navbgImage  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    rect.size.height += 25;
    topView = [[UIView alloc] initWithFrame:rect];
    topView.backgroundColor =COLOR(0, 97, 194);
    topView.backgroundColor =[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:topView];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(10, 8, 60, 60)];
    [btn setBackgroundImage:Image(@"Profile_image") forState:UIControlStateNormal];
    [topView addSubview:btn];
}

-(void)initSetting
{
    settingController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"setting"];
    settingController.rootController = self;
    CGRect rect = CGRectMake(0,self.view.bounds.size.height - 44 - 44,320,self.view.bounds.size.height - 44);
    if (IS_IOS7)
    {
        rect.origin.y += 44;
    }
    [settingController.view setFrame:rect];
    [self.view addSubview:settingController.view];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SKNewsItemController"])
	{
        //SKNewsItemController *newsItem = segue.destinationViewController;
	}
}

-(void)jumpToController:(id)sender
{
    UIDragButton *btn=(UIDragButton *)[(UIDragButton *)sender superview] ;
    //UIViewController* controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:btn.controllerName];
    //[self.navigationController pushViewController:controller animated:YES];
    [self performSegueWithIdentifier:btn.controllerName sender:self];
}

-(void)setBadgeNumber
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIDragButton *btn in upButtons)
        {
            NSString *controllerName=btn.controllerName;
            if([controllerName isEqualToString:@"SKGTaskViewController"])
            {
                //代办
                if ( [LocalMetaDataManager existedNewData:[LocalDataMeta sharedRemind]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedRemind]]];
                }
            }
            else if([controllerName isEqualToString:@"SKMeetingItemController"])
            {
                //会议
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedMeeting]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedMeeting]]];
                }
            }else if([controllerName isEqualToString:@"SKEmailController"]){
                [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedMail]]];
            }else if([controllerName isEqualToString:@"SKNotifyItemController"]){
                //通知
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedNotify]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedNotify]]];
                }
            } else if([controllerName isEqualToString:@"SKWorkNewsController"])  {
                //动态
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedWorkNews]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedWorkNews]]];
                }
            }else if([controllerName isEqualToString:@"SKAddressBookController"]){
                //通讯录
            }else if([controllerName isEqualToString:@"SKAnnouncementItemController"]){
                //公告
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedAnnouncement]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedAnnouncement]]];
                }
            }else if([controllerName isEqualToString:@"SKNewsItemController"]){
                //新闻
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedNews]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedNews]]];
                }
            }else if([controllerName isEqualToString:@"SKCompIssueViewController"]){
                if ([LocalMetaDataManager existedNewData:[LocalDataMeta sharedCompanyDocuments]])
                {
                    [btn setBadgeNumber:@"new"];
                }
                else
                {
                    [btn setBadgeNumber:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedCompanyDocuments]]];
                }
            }
        }
    });
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        BWStatusBar = [[BWStatusBarOverlay alloc] init];
        isFirstLogin = ![APPUtils userUid];
    }
    return self;
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = pageController.currentPage;
    CGRect bounds = bgScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [bgScrollView scrollRectToVisible:bounds animated:animated];
}

- (void)scrollToPage:(int)page
{
    CGRect bounds = bgScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [bgScrollView scrollRectToVisible:bounds animated:YES];
    pageController.currentPage = page;
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

-(void)initPageController
{
    pageController = [[SMPageControl alloc] initWithFrame:CGRectMake((320 - 150)/2., BottomY - 49 - 30, 150, 40)];
    [pageController setHidden:YES];
    [pageController setIndicatorDiameter:8];
    [pageController setNumberOfPages:2];
    [pageController setHidesForSinglePage:YES];
    [pageController setPageIndicatorTintColor:[UIColor blackColor]];
    [pageController setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageController setCurrentPage:0];
    [pageController addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageController];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(bgScrollView.frame);
    NSUInteger page = floor((bgScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageController.currentPage = page;
    if (page == 0) {
        titleLabel.text = @"吴忠主页";
    }else{
        titleLabel.text = @"公司主页";
    }
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    [bgScrollView setContentSize:CGSizeMake((page + 1) * 320, bgScrollView.frame.size.height)];
    SKGridController *controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKGridController"];
    controller.isCompanyPage = !page;
    controller.rootController = self;
    [controllerArray addObject:controller];
    if (controller.view.superview == nil)
    {
        CGRect frame = bgScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [bgScrollView addSubview:controller.view];
    }
}


- (void)loadScrollViewWithClientApp:(SKClientApp*)app PageNo:(int)page
{
    [bgScrollView setContentSize:CGSizeMake((page + 1) * 320, bgScrollView.frame.size.height)];
    SKGridController *controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKGridController"];
    controller.isCompanyPage = !page;
    controller.rootController = self;
    controller.clientApp = app;
    [controllerArray addObject:controller];
    if (controller.view.superview == nil)
    {
        CGRect frame = bgScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self addChildViewController:controller];
        [bgScrollView addSubview:controller.view];
    }
}

-(void)initClientApp
{
    clientAppArray = [NSMutableArray array];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CLIENTAPP;"];
    for (NSDictionary* dict in array) {
        SKClientApp* clientApp = [[SKClientApp alloc] initWithDictionary:dict];
        [clientAppArray addObject:clientApp];
    }
    [self initSrollView];
}

-(void)initSrollView
{
    for (SKClientApp* app in clientAppArray) {
        [self loadScrollViewWithClientApp:app PageNo:[clientAppArray indexOfObject:app]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = @"吴忠主页";
    controllerArray = [NSMutableArray array];
    [self copyXMLToDocument];
    [self initNavBar];
    [self initPageController];
    [self initClientApp];
    if (isFirstLogin) {
        SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
        [FileUtils setvalueToPlistWithKey:@"EPSIZE" Value:@"5"];
        [self presentViewController:loginController animated:NO completion:^{
            NSString* username = [FileUtils valueFromPlistWithKey:@"gpusername"];
            if ([username length] > 0) {
                loginController.userField.text = username;
                loginController.userField.enabled = NO;
            }
        }];
    }else{
        UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"patternlocknav"];
        SKPatternLockController* locker = (SKPatternLockController*)[nav topViewController];
        [locker setDelegate:self];
        [[APPUtils visibleViewController] presentViewController:nav animated:NO completion:^{
            [LocalMetaDataManager restoreAllMetaData];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [topView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [topView setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[SKAppDelegate sharedCurrentUser] isLogged] && [APPUtils currentReachabilityStatus] != NotReachable){
        [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedVersionInfo] delegate:self];
    }
}

-(NSArray *)dataFromXml
{
    NSString *path=[[FileUtils documentPath] stringByAppendingPathComponent:@"main_config.xml"];
    NSData *data=[NSData dataWithContentsOfFile:path];
    DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:data options:0 error:nil];
    NSArray *items = [doc nodesForXPath:@"//app" error:nil];
    NSArray *array=[items sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2)
                    {
                        DDXMLElement *element1=(DDXMLElement *)obj1;
                        DDXMLElement *element2=(DDXMLElement *)obj2;
                        DDXMLNode *locationElement1=[element1 elementForName:@"location"];
                        DDXMLNode *locationElement2=[element2 elementForName:@"location"];
                        int index1=[locationElement1.stringValue integerValue];
                        int index2=[locationElement2.stringValue integerValue];
                        if (index1 > index2) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }if (index1 < index2){
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        return (NSComparisonResult)NSOrderedSame;
                    }];
    return array;
}

-(void)writeDataToXml
{
    NSString *path=[[FileUtils documentPath] stringByAppendingPathComponent:@"main_config.xml"];
    NSData *data=[NSData dataWithContentsOfFile:path];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *items = [doc nodesForXPath:@"//app//controller" error:nil];
    for (int i=0;i<upButtons.count;i++)
    {
        NSString *controllerName=((UIDragButton *)[upButtons objectAtIndex:i]).controllerName;
        for (DDXMLElement *obj in items) {
            if ([obj.stringValue isEqualToString:controllerName])
            {
                DDXMLElement *parentElement= (DDXMLElement *)[obj parent];
                DDXMLElement*locationElement= [parentElement elementForName:@"location"];
                [locationElement setStringValue:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    NSString *result=[[NSString alloc] initWithFormat:@"%@",doc];
    [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 屏保代理函数
-(void)onGetNewVersionDoneWithDic:(NSDictionary *)dic
{
    NSDictionary* vDic=[[NSDictionary alloc] initWithDictionary:[[[dic objectForKey:@"s"] objectAtIndex:0] objectForKey:@"v"]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    //如果服务端版本小于等于当前客户端版本 不弹出更新界面
    if ([[vDic objectForKey:@"NVER"] floatValue] > [appVersion floatValue])
    {
        UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"versionupdatenav"];
        [self presentViewController:nav animated:NO completion:^{
            SKAPPUpdateController* updater = (SKAPPUpdateController*)[nav topViewController];
            [updater setVersionDic:vDic];
        }];
    }
}

-(BOOL)isLoggedCookieValidity
{
    ASIHTTPRequest* validateLogonrequest =
    [ASIHTTPRequest requestWithURL:validloginurl];
    [validateLogonrequest setTimeOutSeconds:15];
    [validateLogonrequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [validateLogonrequest startSynchronous];
    if ([[validateLogonrequest responseData] length] == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)onPatternLockSuccess
{
    if (isFirstLogin) {//这里还有bug//测试 登陆后会不会到这里
        isFirstLogin = NO;
        NSString* username = [FileUtils valueFromPlistWithKey:@"gpusername"];
        if ([username length] >0 ) {
            [FileUtils setvalueToPlistWithKey:@"gpusername" Value:@""];
        }else{
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedVersionInfo] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedSelfEmployee] delegate:0];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedClientApp] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedWorkNewsType] delegate:0];
        }
    }else{
        if ([APPUtils currentReachabilityStatus] != NotReachable) {
            NSDate *date=[FileUtils valueFromPlistWithKey:@"sleepTime"];
            int sleepSecond = [[NSDate date] secondsAfterDate:date];
            if (sleepSecond > 1500 || sleepSecond < 0)
            {
                if (sleepSecond> 1500) {
                    if ([self isLoggedCookieValidity]) {
                        return;
                    }
                }
                [BWStatusBarOverlay showLoadingWithMessage:@"正在登录..." animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[APPUtils AppLogonManager] loginWithUser:[SKAppDelegate sharedCurrentUser]
                                                CompleteBlock:^{
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [BWStatusBarOverlay showSuccessWithMessage:@"登录成功" duration:1 animated:1];
                                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    });
                                                    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedClientApp] delegate:self];
                                                    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedVersionInfo] delegate:self];
                                                    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedRemind] delegate:self];
                                                    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ECONTACTSYNED"]) {
                                                        if ([APPUtils currentReachabilityStatus] == ReachableViaWiFi) {
                                                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
                                                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
                                                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
                                                        }
                                                    }
//                                                    [GetNewVersion getNewsVersionComplteBlock:^(NSDictionary* dict){
//                                                        [self onGetNewVersionDoneWithDic:dict];
//                                                    } FaliureBlock:^(NSDictionary* error){
//                                                    }];
                                                }
                                                 failureBlock:^(NSDictionary* dict){
                                                     [self setBadgeNumber];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                         [BWStatusBarOverlay showErrorWithMessage:dict[@"reason"] duration:1 animated:YES];
                                                         if ([dict[@"reason"] isEqualToString:@"帐号或者密码错误"]) {
                                                             UIAlertView* av = [UIAlertView showAlertString:@"帐号或者密码已经被修改请重新登录"];
                                                             av.delegate = self;
                                                             av.tag = 101;
                                                         }
                                                     });
                                                 }];
                });
            }
        }else{
            [self setBadgeNumber];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SKAppDelegate sharedCurrentUser].logging = NO;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[BWStatusBarOverlay showErrorWithMessage:@"当前没有网络连接" duration:1 animated:YES];
            });
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [FileUtils setvalueToPlistWithKey:@"gpsw" Value:@""];
        [FileUtils setvalueToPlistWithKey:@"gpusername" Value:[APPUtils userUid]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
        SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
        [[APPUtils visibleViewController] presentViewController:loginController animated:NO completion:^{
            [loginController.userField setText:[FileUtils valueFromPlistWithKey:@"gpusername"]];
            [loginController.userField setEnabled:NO];
        }];
    }
}

#pragma mark - 数据代理函数
-(void)didBeginSynData:(LocalDataMeta *)metaData
{
    if ([metaData.dataCode isEqualToString:@"versioninfo"]) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [BWStatusBarOverlay setMessage:@"正在获取版本数据信息..." animated:YES];
//        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([metaData.dataCode isEqualToString:@"employee"]  && ![metaData isUserOwner])  {
            BWStatusBar =  [[BWStatusBarOverlay alloc] init];
            [BWStatusBar showLoadingWithMessage:@"正在同步通讯录..." animated:YES];
            [BWStatusBar setProgressBackgroundColor:COLOR(17, 168, 171)];
        }
    });
}

-(NSString*)ECMPName
{
    NSArray* array = [[DBQueue sharedbQueue] arrayFromTableBySQL:@"select code from T_CLIENTAPP;"];
    NSString* result = [array componentsJoinedByString:@","];
    return result;
}

-(void)didCompleteSynData:(LocalDataMeta *)metaData
{
    if ([metaData.dataCode isEqualToString:@"versioninfo"]) {
        [self setBadgeNumber];
    }
    
    if ([metaData.dataCode isEqualToString:@"employee"] && ![metaData isUserOwner])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ECONTACTSYNED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBar showSuccessWithMessage:@"通讯录同步完成" duration:2 animated:YES];
            //这里需要完善用户信息
        });
    }
    
    if ([metaData.dataCode isEqualToString:@"clientapp"]) {
//        LocalDataMeta* datameta = [LocalDataMeta sharedChannel];
//        [datameta setPECMName:[self ECMPName]];
//        [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedChannel] delegate:self];
        [self initClientApp];
    }
    
    if ([metaData.dataCode isEqualToString:@"channel"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (SKGridController* controller in controllerArray) {
                [controller reloadData];
            }
        });
    }
}

-(void)didCompleteSynData:(NSString *)datacode SV:(int)sv SC:(int)sc LV:(int)lv
{
    
}

-(void)didEndSynData:(LocalDataMeta *)metaData
{
    float p = (float)metaData.lastfrom/metaData.lastcount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([metaData.dataCode isEqualToString:@"employee"] && ![metaData isUserOwner])  {
            [BWStatusBar setProgress:p animated:YES];
            [BWStatusBar setMessage:@"正在同步通讯录..." animated:NO];
        }
    });
}

-(void)didCancelSynData:(LocalDataMeta *)metaData
{
    
}

-(void)didErrorSynData:(LocalDataMeta *)metaData Reason:(NSString *)errorinfo
{
    NSLog(@"didErrorSynData");
}
@end
