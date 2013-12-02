//
//  SKAttachViewController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAttachManger.h"

@interface SKAttachViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,weak)NSMutableDictionary *cmsInfo;
@property SKDocType doctype;
@property BOOL isSearch;
@end
