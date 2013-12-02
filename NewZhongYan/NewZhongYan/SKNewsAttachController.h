//
//  SKNewsAttachController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-22.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface SKNewsAttachController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *authorLabel;
@property (strong, nonatomic)  UILabel *crtmLabel;
@property (strong, nonatomic)  EGOImageView *newsImageView;
@property (strong, nonatomic)  UIWebView   *newsWebView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (nonatomic,strong)NSMutableDictionary *news;
@property BOOL isSearch;
@end
