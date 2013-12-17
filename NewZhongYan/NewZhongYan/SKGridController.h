//
//  SKGridController.h
//  NewZhongYan
//
//  Created by lilin on 13-12-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDragButton.h"
@interface SKGridController : UIViewController<UIDragButtonDelegate>
@property BOOL isCompanyPage;
@property(nonatomic,weak)SKViewController* rootController;
-(void)reloadData;
@end
