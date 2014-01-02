//
//  SKClientApp.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKClientApp.h"
#import "SKMessageEntity.h"
@implementation SKClientApp

-(void)initChanels
{
    NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL where OWNERAPP = '%@' and LEVL = 1;",self.CODE];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    _channels = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        SKChannel* channel = [[SKChannel alloc] initWithDictionary:dict];
        if (![channel.FIDLIST isEqual:[NSNull null]]) {
            [channel restoreVersionInfo];
        }
        [_channels addObject:channel];
    }
}

-(void)initCilentAppVersion
{
    NSString* sql = [NSString stringWithFormat:@"select VERSION from T_CLIENTVERSION where CODE = '%@';",self.CODE];
    self.version = [[DBQueue sharedbQueue] intValueFromSQL:sql];
//    NSLog(@"%d",self.version);
//    if (self.version) {
//        [self initChanels];
//    }
}

-(id)initWithDictionary:(NSDictionary*)appinfo
{
    self = [super init];
    if (self) {
        _channels = nil;
        _CODE = appinfo[@"CODE"];
        _NAME = appinfo[@"NAME"];
        _DEPARTMENT = appinfo[@"DEPARTMENT"];
        _DEFAULTED = appinfo[@"DEFAULTED"];
        _APPTYPE = appinfo[@"APPTYPE"];
        [self initCilentAppVersion];
    }
    return self;
}

+(void)getClientAppWithConpleteBlock:(clientCompleteBlock)block
{
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[SKECMURLManager getAllClientApp]];
    [request startSynchronous];
    if (request.error) {
        @throw [NSException exceptionWithName:@"获取应用列表失败" reason:request.errorinfo userInfo:nil];
    }else{
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:request.responseData];
        if (entity.praserError) {
            if (entity.praserError.code == 2001) {
                //@throw [NSException exceptionWithName:@"获取应用列表失败" reason:@"该用户没有任何应用数据" userInfo:nil];
            }else{
                @throw [NSException exceptionWithName:@"获取应用列表失败" reason:@"服务器数据异常" userInfo:nil];
            }
        }else{
            [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity TableName:@"T_CLIENTAPP"];
            if (block){
                block();
            }
        }
    }
}
@end
