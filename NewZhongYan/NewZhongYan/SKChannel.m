//
//  SKChannel.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKChannel.h"

@implementation SKChannel
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
    }
    return self;
}

@end
