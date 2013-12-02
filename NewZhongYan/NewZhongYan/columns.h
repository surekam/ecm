//
//  columns.h
//  ZhongYan
//
//  Created by linlin on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLNode.h"
@interface columns : NSObject
{
    //属性 包括 name id
    NSDictionary            *columnsDict; //存储属性 
    NSMutableArray         *columnsArray;//存储column 至少一个或者多个
    DDXMLNode         *csnode;//存储column 至少一个或者多个
}
@property(nonatomic,retain)NSDictionary    *columnsDict; //存储属性 
@property(nonatomic,retain)NSMutableArray         *columnsArray;//存储column 至少一个或者多个
@property(nonatomic,retain)DDXMLNode* csnode;
@property BOOL isWritenColumns;
@property BOOL isWrited;
//-(void)showAColumns;
@end
