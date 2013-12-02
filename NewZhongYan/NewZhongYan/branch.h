//
//  branch.h
//  ZhongYan
//
//  Created by linlin on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface branch : NSObject
{
    NSString    *bid;       //选项ID
    NSString    *bname;     //选项名称
    NSString    *ifend;     //默认的选择状态
}

-(void)show;
@property(nonatomic,retain)NSString    *bid; 
@property(nonatomic,retain)NSString    *bname;     //选项名称
@property(nonatomic,retain)NSString    *ifend;     //默认的选择状态
@end
