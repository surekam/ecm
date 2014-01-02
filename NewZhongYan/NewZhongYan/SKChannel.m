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
        _CODE = channelInfo[@"CODE"];
        _NAME = channelInfo[@"NAME"];
        _OWNERAPP = channelInfo[@"OWNERAPP"];
        _TYPELABLE = channelInfo[@"TYPELABLE"];
        _LOGO = channelInfo[@"LOGO"];
        _FIDLIST = channelInfo[@"FIDLIST"];
        _CURRENTID = channelInfo[@"CURRENTID"];
        _PARENTID = channelInfo[@"PARENTID"];
        _HASSUBTYPE = [channelInfo[@"HASSUBTYPE"] boolValue];
        _MAXUPTM = @"";
        _MINUPTM = @"";
    }
    return self;
}

-(void)restoreVersionInfo
{
    NSString* sql = [NSString stringWithFormat:@"select strftime('%%s',max(uptm)) MAXUPTM,strftime('%%s',min(uptm)) MINUPTM from T_DOCUMENTS where channelid in (%@);",_FIDLIST];
    NSDictionary* dict = [[DBQueue  sharedbQueue] getSingleRowBySQL:sql];
    if (dict) {
        if (![dict[@"MAXUPTM"] isEqual:[NSNull null]]) {
            _MAXUPTM = dict[@"MAXUPTM"];
        }
        if (![dict[@"MINUPTM"] isEqual:[NSNull null]]) {
            _MINUPTM = dict[@"MINUPTM"];
        }
        
    }else{
        _MAXUPTM = @"";
        _MINUPTM = @"";
    }
}
@end
