//
//  SKClientApp.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKClientApp.h"

@implementation SKClientApp
-(void)initChanels
{
    NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL where OWNERAPP = '%@'",self.CODE];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    _channels = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        SKChannel* channel = [[SKChannel alloc] initWithDictionary:dict];
        [_channels addObject:channel];
    }
}

-(id)initWithDictionary:(NSDictionary*)appinfo
{
    self = [super init];
    if (self) {
        _CODE = appinfo[@"CODE"];
        _NAME = appinfo[@"NAME"];
        _DEPARTMENT = appinfo[@"DEPARTMENT"];
        _DEFAULTED = appinfo[@"DEFAULTED"];
        _APPTYPE = appinfo[@"APPTYPE"];
    }
    return self;
}

+(void)getClientAppWithConpleteBlock:(ClientBlock)block
{
    
}
@end
