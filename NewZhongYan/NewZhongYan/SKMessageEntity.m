//
//  SKMessageEntity.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMessageEntity.h"
#import "JSONKit.h"
@implementation SKMessageEntity
@synthesize praserError;
-(id)initWithData:(NSData*)JsonData
{
    self = [super init];
    if (self) {
        NSError* error = nil;
        entityDict = [JsonData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error];
        self.praserError = error;
    }
    return self;
}

+(id)entityWithData:(NSData*)JsonData
{
    return [[SKMessageEntity alloc] initWithData:JsonData];
}

-(NSString*)MessageId
{
    if ([[entityDict allKeys] containsObject:@"k"]) {
        return [entityDict objectForKey:@"k"];
    }else{
        return nil;
    }
}

//消息版本号 k = 130622;
-(NSString*)MessageVesion
{
    return [self MessageId];
}

// c = USER;
-(NSString*)MessageCode
{
    if ([[entityDict allKeys] containsObject:@"c"]) {
        return [entityDict objectForKey:@"c"];
    }else{
        return nil;
    }
}

//数据来源
-(NSString*)MessageFrom
{
    if ([[entityDict allKeys] containsObject:@"f"]) {
        return [entityDict objectForKey:@"f"];
    }else{
        return nil;
    }
}

//数据默认要执行的操作
-(int)MessageDefaultAction{
    if ([[entityDict allKeys] containsObject:@"t"]) {
        return [[entityDict objectForKey:@"t"] intValue];
    }else{
        return kActionSelect;//默认
    }
}

-(NSString*)MessageTime{
    if ([[entityDict allKeys] containsObject:@"m"]) {
        return [entityDict objectForKey:@"m"];
    }else{
        return nil;
    }
}

//s 对应的值一般是数组
-(NSInteger)dataItemCount
{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        return [[entityDict objectForKey:@"s"] count];
    }else{
        return 0;
    }
}

-(NSMutableDictionary*)dataItem:(NSInteger)index{
    NSArray* dataArray = [entityDict objectForKey:@"s"];
    if (dataArray.count > index)
    {
        NSMutableDictionary* v_dict = [dataArray objectAtIndex:index];
        return  [v_dict objectForKey:@"v"];
    }else{
        return nil;
    }
}

-(NSMutableArray*)dataItems{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        return [entityDict objectForKey:@"s"];
    }else{
        return nil;
    }
}

-(int)dataItemAction:(NSInteger)index{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        NSArray* dataArray = [entityDict objectForKey:@"s"];
        if (dataArray.count > index){
            return  [[[dataArray objectAtIndex:index] objectForKey:@"t"] intValue];
        }else{
            return kActionSelect;
        }
    }else{
        return kActionSelect;
    }
}
@end
