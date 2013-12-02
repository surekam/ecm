//
//  NSData+AES256.h
//  AES
//
//  Created by Henry Yu on 2009/06/03.
//  Copyright 2010 Sevensoft Technology Co., Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES256)
/**
 * 将数据进行AES256类型的加密
 * @param key   加密的钥匙
 * @return 加密后的数据
 **/
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 * 将数据进行AES256类型的解密
 * @param key  解密的钥匙
 * @return 解密后的数据
 **/
- (NSData *)AES256DecryptWithKey: (NSString *)key;
@end
