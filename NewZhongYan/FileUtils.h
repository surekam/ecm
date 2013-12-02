//
//  FileUtils.h
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "element.h"
#import "column.h"
typedef enum
{
    SKFile,
    SKtext,
    SKMixed,
 	SKImage
} SKColumnTyped;    //列的类型 决定 列如何显示

typedef enum
{
    SKAnyType,
    SKStringType,
    SKDateType,
 	SKIntType,
    SKBinaryType,
    SKNumberType,
    SKPhoneType,
    SKMAilType,
    SKUrlType
} SKColumnRWTyped;  //数据的操作权限

typedef enum
{
    SKNone,
    SKPhrase,       //常用语输入插件
    SKPhonecall,    //拨打电话插件
    SKEmailto,      //发送邮件插件
    SKSignature,    //签名插件
    SKDateinput,     //输入日期型插件
    SKColumnDetail     //明细插件
} SKExtendTyped;    //插件类型

typedef enum {
    rwTypeR=0,
    rwTypeW0=1,
    rwTypeW1=2,
    rwTypeWA0=3,
    rwTypeWA1=4,
    rwTypeWS0=5,
    rwTypeWS1=6,
    rwTypeWD0=7,
    rwTypeWD1=8,
    rwTypeWI0=9,
    rwTypeWI1=10,
    rwTypeWB0=11,
    rwTypeWB1=12,
    rwTypeWN0=13,
    rwTypeWN1=14,
    rwTypeWT0=15,
    rwTypeWT1=16,
    rwTypeWE0=17,
    rwTypeWE1=18,
    rwTypeWU0=19,
    rwTypeWU1=20,
} rwType;//rw类型

@interface FileUtils : NSObject

+ (NSString *)formattedFileSize:(unsigned long long)size;

+ (long long) folderSizeAtPath:(NSString*) folderPath;

+(SKColumnTyped)columnType:(column*)c;


+(BOOL)isElementVisible:(element*)e;
+(BOOL)isWriteType:(NSString*)rwString;
+(BOOL)isWrited:(NSDictionary*)dict;
+(BOOL)isCanBeNull:(NSString*)rwString;
+(SKColumnRWTyped)ClassType:(NSString*)rwString;
+(SKExtendTyped)extendType:(column*)c;
+(SKExtendTyped)extendTypeWithElement:(element*)e;
+(rwType)getRWType:(NSDictionary *)dic;

+ (NSString*)documentPath;

+(id)valueFromPlistWithKey:(NSString*)keyString;

+(void)setvalueToPlistWithKey:(NSString*)keyString Value:(id)valueString;

+(NSMutableArray*)Phrase;

+(void)setPhrase:(NSMutableArray*)phrase;
@end
