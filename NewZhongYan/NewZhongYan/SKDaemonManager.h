//
//  SKDaemonManager.h
//  NewZhongYan
//
//  Created by lilin on 13-12-20.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    SKDaemonClientApp,
    SKDaemonChannel,
}SKDaemontype;    //列的类型 决定 列如何显示

//typedef enum
//{
//    SKRequestRepeated,
//    SKRequestDataError,
//    SKRequestMetaError,
//}SKDaemontErrorType;    //列的类型 决定 列如何显示

#if NS_BLOCKS_AVAILABLE
typedef void (^SKDaemonBasicBlock)(void);
typedef void (^SKDaemonErrorBlock)(NSError* error);
#endif

@interface SKDaemonManager : NSOperation
{
    
}
+(void)SynClientAppData:(SKClientApp*)client complete:(SKDaemonBasicBlock)completeBlock faliure:(SKDaemonErrorBlock)faliureBlock;

+(void)SynChannelWithClientApp:(SKClientApp*)client complete:(SKDaemonBasicBlock)completeBlock faliure:(SKDaemonErrorBlock)faliureBlock;

@end
