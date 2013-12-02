//
//  SKSearchController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSearchInsiderView.h"
#import "SKAttachManger.h"
@interface SKSearchController : UITableViewController
<UISearchBarDelegate,SearchInsideViewProtocol>
{
    SKSearchInsiderView * insiderView;
    
    NSMutableArray      *_dataArray;
    BOOL        isRemote;//是否远程查询
    NSMutableArray*    _keyArray;//用来存储key的数组
    NSInteger   pageindex;

}
@property SKDocType  doctype;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)NSString *AUID;
@property (strong,nonatomic)NSString *BGTM;
@property (strong,nonatomic)NSString *EDTM;
@property (strong,nonatomic)NSString *TITL;
@property (strong,nonatomic)NSString *fid;
@property (strong,nonatomic)UIButton *moreBtn;
@property (strong,nonatomic)NSMutableArray  *keyArray;
@end
