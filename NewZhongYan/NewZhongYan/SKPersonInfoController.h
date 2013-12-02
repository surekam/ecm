//
//  SKPersonInfoController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-14.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface SKPersonInfoController : UIViewController<HPGrowingTextViewDelegate>
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *departmentLabel;
    __weak IBOutlet UILabel *mailLabel;
    __weak IBOutlet HPGrowingTextView *mobileTextField;

    __weak IBOutlet HPGrowingTextView *shortPhoneTextField;
    __weak IBOutlet HPGrowingTextView *telephoneTextField;
    __weak IBOutlet HPGrowingTextView *officeAddressTextField;
    __weak IBOutlet UIView *toolVIew;
    __weak IBOutlet UIScrollView *mainScrollView;
}
@end
