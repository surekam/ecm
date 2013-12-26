//
//  SKECMURLManager.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKECMURLManager.h"

@implementation SKECMURLManager
+(NSURL*)getAllClientApp
{
//    return
//    [NSURL URLWithString:[NSString stringWithFormat:@"http://tam.hngytobacco.com/ZZZobta/aaa-agents/avs/users/coworknews/docs/all"]];
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/all",ZZZobt]];    
}

+(NSURL*)getClientAppVMetaInfoWithVersion:(int)version
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/vmeta?version=%d",ZZZobt,version]];
}

+(NSURL*)getUpdateClientAppWithVersion:(int)version
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/vupdate?version=%d",ZZZobt,version]];
}

+(NSURL*)getAllChannelWithAppCode:(NSString*)code
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/all",ZZZobt,code]];
}

+(NSURL*)getChannelVmetaInfoWithAppCode:(NSString*)code ChannelVersion:(int)version{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/vmeta?version=%d",ZZZobt,code,version]];
}

+(NSURL*)getChannelUpdateInfoWithAppCode:(NSString*)code ChannelVersion:(int)version{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/vupdate?version=%d",ZZZobt,code,version]];
}

@end
