//
//  SKTransactorController.h
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKHTTPRequest.h"
#import "participants.h"
@interface SKTransactorController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    SKHTTPRequest *pRequest;
    participants    *pts;            //参与人详情
    NSString        *bid;
    NSDictionary    *GTaskInfo;
    UITableView     *_tableView;
    CGFloat         currentHeight;
    NSInteger       selectedRow;
}

-(id)initWithDictionary:(NSDictionary*)dictionary  BranchID:(NSString*)abid;
@property(nonatomic,retain)NSString        *bid;
@property(nonatomic,retain)participants    *pts;
@property(nonatomic,retain)NSDictionary    *GTaskInfo;
@property(nonatomic,retain)UITableView     *tableView;
@property(nonatomic,retain)NSString        *branchname;
@end
