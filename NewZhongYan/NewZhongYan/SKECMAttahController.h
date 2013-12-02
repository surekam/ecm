//
//  SKECMAttahController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-21.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
@class SKECMDetail;
@interface SKECMAttahController : UIViewController<UIWebViewDelegate,EGOImageViewDelegate>
{

}
@property (strong,nonatomic)  UILabel *titleLabel;
@property (strong,nonatomic)  UILabel *authorLabel;
@property (strong,nonatomic)  UILabel *crtmLabel;
@property (weak,nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (nonatomic,strong)NSMutableDictionary *news;
@property (nonatomic,strong)SKECMDetail *detail;
@property int curHeight;
@property BOOL isSearch;
@end
