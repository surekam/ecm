//
//  SKAttachButton.m
//  HNZYiPad
//
//  Created by lilin on 13-6-22.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "SKAttachButton.h"
#import "SKAttachViewController.h"
@implementation SKAttachButton
@synthesize DSImageView = _DSImageView;
@synthesize attachLabel = _attachLabel;
@synthesize indicator = _indicator;
@synthesize progresser;
@synthesize attachUrl;
@synthesize filePath;
@synthesize isAttachExisted;
@synthesize request = _request;

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{return 1;}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    if (self.filePath) {
        return [NSURL fileURLWithPath:self.filePath];
    }
    return 0;
}

- (id)initNoBorderBtnWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        previewController = [[SKQLPreviewController alloc] init];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateDisabled];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 3, 5, frame.size.width - 3 - 38)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(5, 40, 5, 40)];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setImage:[UIImage imageNamed:@"doc_downloading.png"] forState:UIControlStateNormal];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.indicator setFrame:CGRectMake(255, 5, 38, 38)];
        [self addSubview:self.indicator];
        
        delelteAttachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [delelteAttachBtn setFrame:CGRectMake(frame.size.width - 30, 10, 25, 25)];
        [delelteAttachBtn addTarget:self action:@selector(deleteAttachment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delelteAttachBtn];
        
        progresser = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [progresser setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 15)];
        [progresser setHidden:YES];
        [self addSubview:progresser];
        
        [self addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)dealloc
{
    [_request clearDelegatesAndCancel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        previewController = [[SKQLPreviewController alloc] init];
        previewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_download_remainder.png"] forState:UIControlStateDisabled];
        [self setImageEdgeInsets:UIEdgeInsetsMake(5, 3, 5, frame.size.width - 3 - 38)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(5, 40, 5, 40)];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setImage:[UIImage imageNamed:@"doc_downloading.png"] forState:UIControlStateNormal];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setFrame:CGRectMake(255, 5, 38, 38)];
        [self addSubview:_indicator];
        
        delelteAttachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [delelteAttachBtn setFrame:CGRectMake(frame.size.width - 35, 10, 25, 25)];
        [delelteAttachBtn addTarget:self action:@selector(deleteAttachment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delelteAttachBtn];
        
        progresser = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [progresser setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 15)];
        [progresser setHidden:YES];
        [self addSubview:progresser];
        [self addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([_request isExecuting])
        {
            [_request clearDelegatesAndCancel];
            [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
            [self.progresser setHidden:YES];
            [self.indicator stopAnimating];
            return;
        }
        _request = [[SKHTTPRequest alloc] initWithURL:self.attachUrl];
        [_request setDownloadDestinationPath:self.filePath];
        [_request setDownloadProgressDelegate:self.progresser];
        [_request setDelegate:self];
        [_request startAsynchronous];
    }
}


-(void)loadAttachment
{
    if (self.attachUrl && self.filePath)
    {
        previewController.dataSource = self;
        previewController.delegate = self;
        previewController.currentPreviewItemIndex = 0;
        if (self.isAttachExisted)
        {
            id<QLPreviewItem> a = [NSURL fileURLWithPath:self.filePath];
            if ([QLPreviewController canPreviewItem:a])
            {
                //[[APPUtils visibleViewController] presentViewController:previewController animated:YES completion:^{
                //}];
                
                [[[APPUtils visibleViewController] navigationController] pushViewController:previewController animated:YES];

            }
            return;
        }
        
        if ([_request isExecuting])
        {
            [_request clearDelegatesAndCancel];
            [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
            [self.progresser setHidden:YES];
            [self.indicator stopAnimating];
            return;
        }
        
        
        if ([APPUtils currentReachabilityStatus] == ReachableViaWWAN) {
            UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络为3G状态，继续下载会使用大量的流量..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alter show];
            return;
        }
        _request = [[SKHTTPRequest alloc] initWithURL:self.attachUrl];
        [_request setShowAccurateProgress:YES];
        [_request setDownloadDestinationPath:self.filePath];
        [_request setDownloadProgressDelegate:self.progresser];
        [_request setDelegate:self];
        [_request startAsynchronous];
    }
}

- (void)requestFinished:(SKHTTPRequest *)req
{
    NSLog(@"%@",req.responseString);
    [self.indicator stopAnimating];
    [self.progresser setHidden:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([req responseStatusCode] != 200)
        {
            [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
            [UIAlertView showAlertString:@"服务器内部异常..."];
            return ;
        }
        [self setIsAttachExisted:YES];

        id<QLPreviewItem> a = [NSURL fileURLWithPath:self.filePath];
        if ([QLPreviewController canPreviewItem:a])
        {
            UIViewController* controller = [APPUtils visibleViewController];
            if ([controller isKindOfClass:[SKQLPreviewController class]]) {
                return;
            }
            [[controller navigationController] pushViewController:previewController animated:YES];
        }
    });
}

- (void)requestFailed:(SKHTTPRequest *)req
{
    [self.indicator stopAnimating];
    [self.progresser setHidden:YES];
    [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
    if (req.errorcode) {
        [UIAlertView showAlertString:@"服务器不存在该资源"];
    }else{
        [UIAlertView showAlertString:@"获取数据失败"];
    }
}

- (void)request:(SKHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary*)responseHeaders
{
    //NSLog(@"%@",responseHeaders);
}

- (void)requestStarted:(SKHTTPRequest *)request
{
    [self.indicator startAnimating];
    [self.progresser setHidden:NO];
}

-(void)deleteAttachment:(id)sender
{
    NSError* error = nil;
    [SKHTTPRequest removeFileAtPath:self.filePath error:&error];
    if (error) {
        NSLog(@"删除失败");
    }else{
        [self setIsAttachExisted:NO];
    }
}

-(void)setIsAttachExisted:(BOOL)attachExisted
{
    isAttachExisted = attachExisted;
    [delelteAttachBtn setHidden:!attachExisted];
    if (attachExisted) {
        [self setImage:[UIImage imageNamed:@"doc_downloaded.png"] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@"doc_downloading.png"] forState:UIControlStateNormal];
    }
}
@end
