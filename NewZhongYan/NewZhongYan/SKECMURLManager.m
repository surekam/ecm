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
@end
