//
//  SKViewController.h
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDragButton.h"
#import "SKPatternLockController.h"
#import "SKNewsItemController.h"
#import "UIButton+WebCache.h"
@interface SKViewController : UIViewController<UIDragButtonDelegate,drawPatternLockDelegate,SKDataDaemonHelperDelegate>
{
    NSMutableArray *upButtons;
    BOOL isFirstLogin;
}
@end
