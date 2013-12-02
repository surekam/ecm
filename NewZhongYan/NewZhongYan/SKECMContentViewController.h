//
//  SKECMContentViewController.h
//  NewZhongYan
//
//  Created by 蒋雪莲 on 13-11-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@class SKECMDetail;

@interface SKECMContentViewController : UIViewController<UIWebViewDelegate,EGOImageViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *crtmLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (nonatomic,strong)NSMutableDictionary *news;
@property (nonatomic,strong)SKECMDetail *detail;
@property int curHeight;
@property BOOL isSearch;
@end
