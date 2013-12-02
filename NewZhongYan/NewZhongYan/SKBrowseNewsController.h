//
//  SKBrowseNewsController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-25.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLazyScrollView.h"
@interface SKBrowseNewsController : UIViewController <UIScrollViewDelegate,DMLazyScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray  *viewControllers;   //详细内容  存储所有的内容
    NSArray         *contentList;       //存储新闻的内容
    NSInteger       kNumberOfPages;
    NSInteger       KinitialPage;       //初始页面
    NSMutableArray*    viewControllerArray;
}

@property (nonatomic, strong) NSArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSMutableDictionary    *currentDictionary;
@property (strong, nonatomic) IBOutlet  DMLazyScrollView *lazyScrollView;
@property  NSInteger       kNumberOfPages;
@end
