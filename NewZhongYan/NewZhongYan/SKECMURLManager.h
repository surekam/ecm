//
//  SKECMURLManager.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKECMURLManager : NSObject
#pragma mark -
#pragma mark ===========  应用接口  =========
#pragma mark -
/**
 *  用户获取应用列表接口
 *      iv-user不能为空，否则返回错误码：
 *      #3010,用户尚未登录成功
 *  @return 数据集合消息实体如果无数据则返回异常消息实体
 */
+(NSURL*)getAllClientApp;

/**
 *  返回指定版本至最新版本的数据集合元信息  从request头部获取iv-user用户名
 *
 *  @param version 指定版本号
 *
 *  @return 数据集合消息实体 如果无数据则返回异常消息实体
 */
+(NSURL*)getClientAppVMetaInfoWithVersion:(int)version;

/**
 *  用户更新应用列表接口
 *
 *  @param version 指定版本号
 *
 *  @return 数据集合消息实体如果无数据则返回异常消息实体
 */
+(NSURL*)getUpdateClientAppWithVersion:(int)version;

#pragma mark -
#pragma mark ===========  频道接口  =========
#pragma mark -


#pragma mark -
#pragma mark ===========  频道类型接口  =========
#pragma mark -


#pragma mark -
#pragma mark ===========  文档类型接口接口  =========
#pragma mark -
@end
