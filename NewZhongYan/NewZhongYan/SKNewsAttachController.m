//
//  SKNewsAttachController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-22.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKNewsAttachController.h"
#import "SKViewController.h"
#import "SKAttachManger.h"
#import "UIImageView+Addition.h"
@interface SKNewsAttachController ()
{
    NSMutableArray* attachmentItem;
    SKAttachManger *AM;//附件管理
    CGFloat height;
}
@end

@implementation SKNewsAttachController
- (IBAction)home:(id)sender {
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popToRootViewControllerAnimated:YES];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
-(void)initData
{
    AM = [[SKAttachManger alloc] initWithCMSInfo:_news];
    AM.doctype = SKNews;
    height = 100;
}

-(void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        if (!_isSearch) {
            [_bgscrollview setFrame:CGRectMake(0, 0, 320, 504)];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (IS_IOS7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = [_news objectForKey:@"TITL"];
    [_titleLabel sizeToFit];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_bgscrollview addSubview:_titleLabel];

    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    if ([[_news allKeys] containsObject:@"AUNAME"]) {
        _authorLabel.text = [NSString stringWithFormat:@"作者 : %@",[_news objectForKey:@"AUNAME"]];
    }else{
        _authorLabel.text = [NSString stringWithFormat:@"作者 : %@",[_news objectForKey:@"AUID"]];

    }
    _authorLabel.textColor = [UIColor lightGrayColor];
    [_bgscrollview addSubview:_authorLabel];
    
    NSString* crtm = [_news objectForKey:@"CRTM"];
    if (crtm.length > 16) {//这种情况可能出现在远程查询
        NSDate   *notifyDate = [DateUtils stringToDate:crtm DateFormat:dateTimeFormat];
        NSString *notifyTime = [DateUtils dateToString:notifyDate DateFormat:displayDateTimeFormat];
        crtm = [notifyTime substringToIndex:16];
    }
    _crtmLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _crtmLabel.font = [UIFont systemFontOfSize:14];
    _crtmLabel.textAlignment = UITextAlignmentRight;
    _crtmLabel.text = crtm;
    _crtmLabel.textColor = [UIColor lightGrayColor];
    [_crtmLabel setBackgroundColor:[UIColor clearColor]];
    [_bgscrollview addSubview:_crtmLabel];
    
    UIImageView* DividingLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_line.png"]];
    [DividingLines setFrame:CGRectMake(10, CGRectGetMaxY(_crtmLabel.frame), 300, 2)];
    [_bgscrollview addSubview:DividingLines];
    
    if ([AM pictureNews])
    {
        _newsImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(DividingLines.frame), 200, 160)];
        [_bgscrollview addSubview:_newsImageView];
        [self loadimageAttachement];
    }
    
    CGFloat newsWebY = _newsImageView ? CGRectGetMaxY(_newsImageView.frame):CGRectGetMaxY(DividingLines.frame);
    _newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, newsWebY, 300, 100)];
    _newsWebView.delegate = self;
    _newsWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    UIScrollView* webScrollView =  (UIScrollView*)[[_newsWebView subviews] objectAtIndex:0];
    [webScrollView setScrollEnabled:NO];
    [_bgscrollview addSubview:_newsWebView];
    
    UIPinchGestureRecognizer* pinchRecognizer= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [_newsWebView addGestureRecognizer:pinchRecognizer];
    [self loadContentAttachement];
}

-(void)loadContentAttachement
{
    NSString* contentPath = [AM contentPath];
    NSURL*    contentUrl =  [AM ContentURL];;
    if ([AM contentExisted])
    {
        NSString* contentstring = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        NSDictionary* dic = [contentstring objectFromJSONString];
        if ([[dic allKeys] containsObject:@"c"] || [[dic objectForKey:@"c"] isEqualToString:@"EXCEPTION"]) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }else{
            [_newsWebView loadHTMLString:contentstring baseURL:contentUrl];
            return;
        }
    }
    
    SKHTTPRequest* Request = [[SKHTTPRequest alloc] initWithURL:contentUrl];
    __weak SKHTTPRequest* contentRequest = Request;
    [contentRequest setDownloadDestinationPath:contentPath];
    [contentRequest setCompletionBlock:^{
        if ([contentRequest responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }else{
            NSString* contentstring = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
            [_newsWebView loadHTMLString:contentstring baseURL:nil];
        }
    }];
    [contentRequest setFailedBlock:^{
        [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showMessage:[NetUtils userInfoWhenRequestOccurError:contentRequest.error] duration:1 animated:1];
        });
    }];
    [Request startAsynchronous];
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        if (pinchRecognizer.velocity > 0) {
            height +=5;
            height =   height > 150 ? 150 :height;
        }else{
            height -=5;
            height =   height < 100 ? 100 :height;
        }
        NSString* newframestring =
        [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",height];
        [[_newsWebView stringByEvaluatingJavaScriptFromString:newframestring] floatValue];
        CGRect newFrame = _newsWebView.frame;
        CGFloat actualheight = [[_newsWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        if (actualheight < newFrame.size.height) {
            actualheight -= 30;
        }
        newFrame.size.height = actualheight;
        _newsWebView.frame = newFrame;
        _bgscrollview.contentSize = CGSizeMake(320,CGRectGetMaxY(_newsWebView.frame));
    }
}

-(void)loadimageAttachement
{
    if (![AM pictureNews]) {
        return;
    }
    NSString* imagePath = [AM imagePath];
    NSURL*    imageUrl =  [AM imageURL];
    if ([AM imageExisted]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithContentsOfFile:[AM imagePath]];
            if (!image) {
                [ASIHTTPRequest removeFileAtPath:imagePath error:0];
                [self loadimageAttachement];
            }
            [_newsImageView setImage:[UIImage imageWithContentsOfFile:[AM imagePath]]];
            [_newsImageView setCaption:[AM.CMSInfo objectForKey:@"TITL"]];
            [_newsImageView addDetailShow];
        });
        return;
    }
     SKHTTPRequest* request = [[SKHTTPRequest alloc] initWithURL:imageUrl];
    __weak SKHTTPRequest*imageRequest = request;
    [imageRequest setDownloadDestinationPath:imagePath];
    [imageRequest setTimeOutSeconds:15];
    [imageRequest setCompletionBlock:^{
        if ([imageRequest responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:imagePath error:0];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _newsImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            [_newsImageView setCaption:[AM.CMSInfo objectForKey:@"TITL"]];
            [_newsImageView addDetailShow];
        });
    }];
    [imageRequest setFailedBlock:^{
        if ([AM imageExisted]) {
            [ASIHTTPRequest removeFileAtPath:imagePath error:0];
        }
    }];
    [imageRequest startAsynchronous];
}

- (void)webViewDidFinishLoad:(UIWebView *) webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    [_bgscrollview setContentSize:CGSizeMake(320, CGRectGetMaxY(webView.frame))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
