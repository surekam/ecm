//
//  SKRootCell.h
//  ZhongYan
//
//  Created by 李 林 on 4/12/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SKTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *crtmLabel;
    __weak IBOutlet UIImageView *stateView;
    __weak IBOutlet UIImageView *attachView;
}

//当实例化这个cell 时 重新调整子视图的位置
-(void)resizeTheHeight;
-(void)resizeCellHeight;
//渲染本cell
-(void)setDataDictionary:(NSDictionary*)dictionary;
-(void)setRemindInfo:(NSDictionary*)remind;
-(void)setCMSInfo:(NSDictionary*)info;

-(void)setECMInfo:(NSDictionary*)info;
//用于测试
-(void)setCMSTestInfo;
@end
