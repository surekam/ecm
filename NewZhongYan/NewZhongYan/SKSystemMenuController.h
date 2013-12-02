//
//  SKSystemMenuController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-9.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@interface SKSystemMenuController : UIViewController<UIGestureRecognizerDelegate>
{
    CGPoint StartPoint;
    CGPoint MovePoint;
    BOOL            isSystemMenuShow;
    UIView          *topImageView;
    UIImageView     *imageView;
}
@property(nonatomic,weak)SKViewController* rootController;
@end
