//
//  SKECMSearchController.h
//  NewZhongYan
//
//  Created by lilin on 14-1-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKECMSearchController : UITableViewController<UISearchBarDelegate>
{
    NSMutableArray      *_dataArray;
    BOOL                isRemote;//是否远程查询
    NSMutableArray      *_keyArray;//用来存储key的数组
    NSInteger           pageindex;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)UIButton *moreBtn;
@end
