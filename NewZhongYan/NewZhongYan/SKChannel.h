//
//  SKChannel.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKChannel : NSObject
@property(nonatomic,strong)NSString* CODE;      //频道编码
@property(nonatomic,strong)NSString* NAME;      //频道名称
@property(nonatomic,strong)NSString* OWNERAPP;
@property(nonatomic,strong)NSString* TYPELABLE;
@property(nonatomic,strong)NSString* LOGO;
@property(nonatomic,strong)NSString* FIDLIST;


@property BOOL HASSUBTYPE;
@property(nonatomic,strong)NSMutableArray* channeltypes;

-(id)initWithDictionary:(NSDictionary*)channelInfo;
@end
