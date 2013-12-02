//
//  SKAttachViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAttachViewController.h"
#import "DataServiceURLs.h"
#import "SKAttachButton.h"
@interface SKAttachViewController ()
{
    UILabel*        TITLLabel;
    UILabel*        AUNAMELabel;//通知时间
    UILabel*        TIMELabel;  //通知内容
    UIWebView*      contentWebView;
    
    SKAttachManger *AM;//附件管理
    LocalDataMeta               *dataMeta;
}

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end

@implementation SKAttachViewController
-(void)initData
{
    AM = [[SKAttachManger alloc] initWithCMSInfo:_cmsInfo];
    AM.doctype = _doctype;
    NSLog(@"%d",_doctype);
    if (_doctype == SKNotify)
    {
        dataMeta = [LocalDataMeta sharedNotify];
        self.title = @"通知详情";
    }
    else if (_doctype == SKMeet)
    {
        dataMeta = [LocalDataMeta sharedMeeting];
        self.title = @"会议详情";
    }
    else if (_doctype == SKAnnounce)
    {
        dataMeta = [LocalDataMeta sharedAnnouncement];
        self.title = @"公告详情";
    }else if (_doctype == SKCodocs) {
        dataMeta = [LocalDataMeta sharedCompanyDocuments];
        self.title = @"公司公文详情";
    } else if (_doctype == SKWorkNews){
        dataMeta = [LocalDataMeta sharedWorkNews];
        self.title = @"工作动态详情";
    }
    else
    {
        dataMeta = [LocalDataMeta sharedNotify];
        self.title = @"通知详情";
    }
}

-(void)loadContentAttachement
{
    NSString* contentPath = [AM contentPath];
    NSURL*    contentUrl = [[DataServiceURLs DataServiceURLs:dataMeta] attmsURL:@"CONTENT" attach:AM.tid];
    if ([AM contentExisted]) {
        NSString* contentstring = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        [contentWebView loadHTMLString:contentstring baseURL:contentUrl];
        return;
    }
    
    SKHTTPRequest * request = [[SKHTTPRequest alloc] initWithURL:contentUrl];
    [request setDownloadDestinationPath:contentPath];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        if ([req responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }else{
            NSString* contentstring = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
            [contentWebView loadHTMLString:contentstring baseURL:nil];
        }
    }];
    [request setFailedBlock:^{
        [ASIHTTPRequest removeFileAtPath:contentPath error:0];
    }];
    [request startSynchronous];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    TITLLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    TITLLabel.font = [UIFont boldSystemFontOfSize:18];
    TITLLabel.numberOfLines = 0;
    TITLLabel.text = [AM.CMSInfo objectForKey:@"TITL"];
    [TITLLabel sizeToFit];//保证与上边界的距离不变 必须要加
    [TITLLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [TITLLabel setTextColor:[UIColor darkTextColor]];
    [_bgScrollView addSubview:TITLLabel];
    
    //作者
    AUNAMELabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(TITLLabel.frame) + 5, 150, 20)];
    AUNAMELabel.font = [UIFont systemFontOfSize:12];
    AUNAMELabel.text = [NSString stringWithFormat:@"作者 : %@",[AM.CMSInfo objectForKey: _isSearch ? @"AUID":@"AUNAME"]];
    [AUNAMELabel sizeToFit];
    [AUNAMELabel setTextColor:[UIColor darkGrayColor]];
    [_bgScrollView addSubview:AUNAMELabel];
    
    //时间
    TIMELabel = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(TITLLabel.frame) + 5, 150, 20)];
    TIMELabel.font = [UIFont systemFontOfSize:12];
    TIMELabel.numberOfLines = 0;
    TIMELabel.textAlignment = UITextAlignmentRight;
    TIMELabel.text = [[[AM.CMSInfo objectForKey:@"CRTM"]
                       stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16];
    [TIMELabel sizeToFit];
    [_bgScrollView addSubview:TIMELabel];
    
    UIImageView* DividingLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_line.png"]];
    [DividingLines setFrame:CGRectMake(10, CGRectGetMaxY(TIMELabel.frame), 300, 2)];
    [_bgScrollView addSubview:DividingLines];

    CGFloat curHeight = CGRectGetMaxY(DividingLines.frame) + 2;
    for (int i = 0; i < [AM.attachItems count]; ++i)
    {
        NSString* btnTitle = [AM.attachItems objectAtIndex:i];
        SKAttachButton* attachmentButton = [[SKAttachButton alloc] initWithFrame:CGRectMake(10,curHeight, 300, 48)];
        attachmentButton.filePath = [AM attachmentPathWithName:btnTitle];
        attachmentButton.attachUrl = [[DataServiceURLs DataServiceURLs:dataMeta] attmsURL:btnTitle attach:AM.tid];
        attachmentButton.isAttachExisted = [AM attachmentExisted:btnTitle];
        [attachmentButton setTitle:btnTitle forState:UIControlStateNormal];
        [_bgScrollView addSubview:attachmentButton];
        curHeight += 48;
    }
    contentWebView = [[UIWebView alloc] initWithFrame:
                      CGRectMake(10, curHeight, 300,100)];
    contentWebView.delegate = self;
    [_bgScrollView addSubview:contentWebView];
    UIScrollView* webScrollView =  (UIScrollView*)[[contentWebView subviews] objectAtIndex:0];
    [webScrollView setScrollEnabled:NO];
    [contentWebView setBackgroundColor:[UIColor redColor]];
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadContentAttachement];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    _bgScrollView.contentSize = CGSizeMake(320,CGRectGetMaxY(webView.frame));
}
@end
