//
//  SKEDetailController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-31.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface SKEDetailController : UIViewController
<MFMessageComposeViewControllerDelegate>
@property(nonatomic,weak)NSMutableDictionary  *employeeInfo;
@end
