//
//  GetNewVersion.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "GetNewVersion.h"
#import "SKHTTPRequest.h"
#import "DataServiceURLs.h"
#import "utils.h"
#import "JSONKit.h"
@implementation GetNewVersion
-(void)getNewsVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSURL* newVersionURL=[DataServiceURLs getNewVersion:appVersion];
    __weak SKHTTPRequest *request = [SKHTTPRequest requestWithURL:newVersionURL];
    [request setCompletionBlock:^{
        NSDictionary *dic=[[request responseData] objectFromJSONData];
        [self performSelectorOnMainThread:@selector(getNewsDone:) withObject:dic waitUntilDone:NO];
    }];
    
    [request setFailedBlock:^
    {
        NSLog(@"获取版本数据错误:%@",request.errorinfo);
    }];
    [request startAsynchronous];
}

-(void)getNewsDone:(NSDictionary *)dic
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onGetNewVersionDoneWithDic:)])
     {
         [self.delegate onGetNewVersionDoneWithDic:dic];
     }
}

+(void)getNewsVersionComplteBlock:(completeBlock)block FaliureBlock:(errorBlock)errorinfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSURL* newVersionURL=[DataServiceURLs getNewVersion:appVersion];
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:newVersionURL];
    __weak SKHTTPRequest *req = request;
    [request setCompletionBlock:^{
        NSDictionary *dic=[[req responseData] objectFromJSONData];
        if (block) {
            block(dic);
        }
    }];
    [request setFailedBlock:^{
         if (errorinfo) {
             errorinfo(@{@"reason": req.errorinfo});
         }
     }];
    [request startAsynchronous];
}
@end
