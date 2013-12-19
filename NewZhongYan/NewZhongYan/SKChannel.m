//
//  SKChannel.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKChannel.h"

@implementation SKChannel
-(void)initChannelTypes
{
    NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNELTP where OWNER = '%@'",self.CODE];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    if (array.count) {
        _channeltypes = [NSMutableArray array];
        for (NSDictionary* dict in array) {
            SKChanneltp* channeltp = [[SKChanneltp alloc] initWithDictionary:dict];
            [_channeltypes addObject:channeltp];
        }
    }else{
        _channeltypes = nil;
    }

}

-(id)initWithDictionary:(NSDictionary*)channelInfo
{
    self = [super init];
    if (self) {
        _CODE = channelInfo[@"TID"];
        _NAME = channelInfo[@"NAME"];
        _OWNERAPP = channelInfo[@"OWNERAPP"];
        _TYPELABLE = channelInfo[@"TYPELABLE"];
        _LOGO = channelInfo[@"LOGO"];
        _FIDLIST = channelInfo[@"FIDLIST"];
        _HASSUBTYPE = [channelInfo[@"HASSUBTYPE"] boolValue];
        if (_HASSUBTYPE) {
            [self initChannelTypes];
        }else{
            _channeltypes = nil;
        }
    }
    return self;
}

@end
