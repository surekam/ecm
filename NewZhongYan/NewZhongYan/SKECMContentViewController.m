//
//  SKECMContentViewController.m
//  NewZhongYan
//
//  Created by 蒋雪莲 on 13-11-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKECMContentViewController.h"
#import "SKViewController.h"
#import "SKAttachManger.h"
#import "UIImageView+Addition.h"
#import "DDXML.h"
#import "Element.h"
#import "Content.h"
#import "SKECMDetail.h"
#import "SKAttachButton.h"

@interface SKECMContentViewController ()
{
    NSMutableArray* attachmentItem;
    SKAttachManger *AM;//附件管理
    CGFloat height;
}
@end

@implementation SKECMContentViewController
@synthesize detail;

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
    [self loadContent];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    [_titleLabel setBackgroundColor:[UIColor redColor]];
    _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = detail.title;
    [_titleLabel sizeToFit];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_bgscrollview addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.text = [NSString stringWithFormat:@"作者 : %@",detail.author];
    _authorLabel.textColor = [UIColor lightGrayColor];
    [_bgscrollview addSubview:_authorLabel];
    
    _crtmLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_titleLabel.frame), 150, 20)];
    _crtmLabel.font = [UIFont systemFontOfSize:14];
    _crtmLabel.textAlignment = UITextAlignmentRight;
    _crtmLabel.text = detail.time;
    _crtmLabel.textColor = [UIColor lightGrayColor];
    [_crtmLabel setBackgroundColor:[UIColor clearColor]];
    [_bgscrollview addSubview:_crtmLabel];
    
    UIImageView* DividingLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_line.png"]];
    [DividingLines setFrame:CGRectMake(10, CGRectGetMaxY(_crtmLabel.frame), 300, 2)];
    [_bgscrollview addSubview:DividingLines];
    
    _curHeight = CGRectGetMaxY(DividingLines.frame);
    
    for (Content *content in detail.body) {
        [self showContent:content];
    }
    for (Content *content in detail.attachment) {
        [self showContent:content];
    }
//    for (Content *content in detail.inscribe) {
//        [self showContent:content];
//    }
//    for (Content *content in detail.addition) {
//        [self showContent:content];
//    }
    
}

-(void) showContent:(Content *) content{
    if (content.type == nil) {
        [self addText:content];
    }
    else if ([content.type rangeOfString:@"application/"].location != NSNotFound) {
        [self addAttachement:content];
    }
    //如果是图像
    else if([content.type isEqualToString:@"image"])
    {
        [self addImage:content];
    }
    //如果是html
    else if ([content.type isEqualToString:@"text/html"])
    {
        [self addHtml:content];
    }
    //如果是文字
    else if ([content.type isEqualToString:@"text/plain"])
    {
        [self addText:content];
    }
    
}

-(void) addAttachement:(Content *) content{
    _curHeight += 2;
    NSString* btnTitle = content.name;
    SKAttachButton* attachmentButton = [[SKAttachButton alloc] initWithFrame:CGRectMake(10,_curHeight, 300, 48)];
    attachmentButton.filePath = [[AM TIDPath]stringByAppendingPathComponent:content.name];
    attachmentButton.attachUrl = [NSURL URLWithString:content.value];
    attachmentButton.isAttachExisted = [AM fileExisted:attachmentButton.filePath];
    [attachmentButton setTitle:btnTitle forState:UIControlStateNormal];
    [_bgscrollview addSubview:attachmentButton];
    _curHeight += 48;//48 button 的高度
}
-(void) addImage:(Content *) content{
    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(60, _curHeight, 200, 160)];
    _curHeight += 160;
    NSString *imagePath = [[AM TIDPath]stringByAppendingPathComponent:content.name];
    
    if ([AM fileExisted:imagePath]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
            if (!image) {
                [ASIHTTPRequest removeFileAtPath:imagePath error:0];
//                [self loadimageAttachement];
            }
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
            [imageView setCaption:content.name];
            [imageView addDetailShow];
//        });
        return;
    }
    NSURL* imageUrl =  [NSURL URLWithString:content.value];
    
    SKHTTPRequest* request = [[SKHTTPRequest alloc] initWithURL:imageUrl];
    __weak SKHTTPRequest*imageRequest = request;
    [imageRequest setDownloadDestinationPath:imagePath];
    [imageRequest setTimeOutSeconds:15];
    [request setCompletionBlock:^{
        if ([imageRequest responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:imagePath error:0];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
            [imageView setCaption:content.name];
            [imageView addDetailShow];
        });
    }];
    [request setFailedBlock:^{
        if ([AM fileExisted:imagePath]) {
            [ASIHTTPRequest removeFileAtPath:imagePath error:0];
        }
    }];
    [request startAsynchronous];
    [_bgscrollview addSubview:imageView];
    _curHeight += 2;
}
-(void) addHtml:(Content *) content{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, _curHeight, 300, 100)];
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    UIScrollView* webScrollView =  (UIScrollView*)[[webView subviews] objectAtIndex:0];
    [webScrollView setScrollEnabled:NO];
    [_bgscrollview addSubview:webView];
    
    UIPinchGestureRecognizer* pinchRecognizer= [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:withWebView:)];
    [webView loadHTMLString:content.value baseURL:Nil];
    [webView addGestureRecognizer:pinchRecognizer];
}
-(void) addText:(Content *) content{
    
}

-(void)loadContent
{
    NSString* contentPath = [AM contentPath];
    NSURL*    contentUrl =  [NSURL URLWithString:@"http://10.159.30.88/aaa-agents/xml/ECMDetail.xml"];
    if ([AM contentExisted])
    {
        [self analysisXml:contentPath];
        return;
    }
    
    SKHTTPRequest* Request = [[SKHTTPRequest alloc] initWithURL:contentUrl];
    __weak SKHTTPRequest* contentRequest = Request;
    [contentRequest setDownloadDestinationPath:contentPath];
    [contentRequest setCompletionBlock:^{
        if ([contentRequest responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }else{
            [self analysisXml:contentPath];
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

-(void) analysisXml:(NSString *) contentPath
{
    NSData *data=[NSData dataWithContentsOfFile:contentPath];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:0];
    detail = [[SKECMDetail alloc] init];
    
    DDXMLElement  *head= (DDXMLElement*)[[doc nodesForXPath:@"//head" error:nil] objectAtIndex:0];
    
    DDXMLElement  *title= (DDXMLElement*)[[head nodesForXPath:@"//title" error:nil] objectAtIndex:0];
    detail.title = [title stringValue];
    
    DDXMLElement  *author= (DDXMLElement*)[[head nodesForXPath:@"//author" error:nil] objectAtIndex:0];
    detail.author = [author stringValue];
    
    DDXMLElement  *time = (DDXMLElement*)[[head nodesForXPath:@"//time" error:nil] objectAtIndex:0];
    detail.time = [time stringValue];
    
    DDXMLElement  *body= (DDXMLElement*)[[doc nodesForXPath:@"//body" error:nil] objectAtIndex:0];
    detail.body = [self analysisXmlElement:body];
    
    DDXMLElement  *attachment= (DDXMLElement*)[[doc nodesForXPath:@"//attachment" error:nil] objectAtIndex:0];
    detail.attachment = [self analysisXmlElement:attachment];
    
    DDXMLElement  *inscribe= (DDXMLElement*)[[doc nodesForXPath:@"//inscribe" error:nil] objectAtIndex:0];
    detail.inscribe = [self analysisXmlElement:inscribe];
    
    DDXMLElement  *addition= (DDXMLElement*)[[doc nodesForXPath:@"//addition" error:nil] objectAtIndex:0];
    detail.addition = [self analysisXmlElement:addition];
}

-(NSMutableArray*) analysisXmlElement:(DDXMLElement *) element
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[element childCount]];
    for (DDXMLElement* eleContent in [element children] ) {
        if ([eleContent isMemberOfClass:[DDXMLNode class]]){
            continue;
        }
        Content *content = [[Content alloc] init];
        DDXMLNode *idatta = [eleContent attributeForName:@"id"];
        if (idatta != nil) {
            content.idatta = [idatta stringValue];
        }
        DDXMLNode *name = [eleContent attributeForName:@"name"];
        if (name != nil) {
            content.name = [name stringValue];
        }
        DDXMLNode *type = [eleContent attributeForName:@"type"];
        if (type != nil) {
            content.type = [type stringValue];
        }
        content.value = [eleContent stringValue];
        [array addObject:content];
    }
    return array;
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinchRecognizer withWebView:(UIWebView*) webView
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
        [[webView stringByEvaluatingJavaScriptFromString:newframestring] floatValue];
        CGRect newFrame = webView.frame;
        CGFloat actualheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        if (actualheight < newFrame.size.height) {
            actualheight -= 30;
        }
        newFrame.size.height = actualheight;
        webView.frame = newFrame;
        _bgscrollview.contentSize = CGSizeMake(320,CGRectGetMaxY(webView.frame));
    }
}
- (void)webViewDidFinishLoad:(UIWebView *) webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
//    _curHeight += CGRectGetMaxY(webView.frame);
    [_bgscrollview setContentSize:CGSizeMake(320, _curHeight)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
