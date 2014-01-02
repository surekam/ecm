//
//  SKECMRootController.h
//  NewZhongYan
//
//  Created by lilin on 13-12-26.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "SKChannel.h"
@interface SKECMRootController : UIViewController
<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    __weak IBOutlet UIView *toolView;
}

@property (nonatomic,weak)IBOutlet PullingRefreshTableView *tableView;
@property (nonatomic,weak)SKChannel* channel;
@end
