//
//  SKAttachButton.h
//  HNZYiPad
//
//  Created by lilin on 13-6-22.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "SKQLPreviewController.h"
@interface SKAttachButton : UIButton<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIAlertViewDelegate>
{
    UIImageView *_DSImageView;// download State Image View
    UILabel     *_attachLabel;
    UIActivityIndicatorView *_indicator;
    UIProgressView* progresser;
    
    SKHTTPRequest* _request;
    UIButton* delelteAttachBtn;
    SKQLPreviewController* previewController;
}


@property(nonatomic,strong)NSURL* attachUrl;
@property(nonatomic,strong)NSString* filePath;
@property(nonatomic,strong)UIImageView *DSImageView;
@property(nonatomic,strong)UILabel *attachLabel;
@property(nonatomic,strong)UIActivityIndicatorView * indicator;
@property(nonatomic,strong)UIProgressView* progresser;
@property(nonatomic,strong)SKHTTPRequest* request;
@property(nonatomic)BOOL isAttachExisted;


- (id)initNoBorderBtnWithFrame:(CGRect)frame;
@end
