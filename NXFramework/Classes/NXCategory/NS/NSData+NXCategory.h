//
//  NSData+Crypto.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NXCategory)

/**
 *  判断不为空
 *
 *  @return YES 为不为空
 */
- (BOOL)nx_isNotEmpty;

/**
 * SHA1 加密 @see http://www.jianshu.com/p/520abe10e895
 * @return 加密后的data
 */
- (NSData *)nx_encryptedDataUsingSHA1WithKey:(NSData *)key;

/**
 * MD5 加密
 * @return 加密后的data
 */
- (NSData *)nx_dataWithMD5Hash;

/**
 *  判断数据类型
 *
 *  @return 类型  e.g. image/jpeg
 */
- (NSString *)nx_contentType;

/**
 *  @brief 是否包含前缀
 *
 *  @param prefix 前缀字符
 *  @param length 前缀字符长度
 */
- (BOOL)nx_hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;

/**
 *  @brief 是否包含后缀
 *
 *  @param suffix 后缀字符
 *  @param length 后缀字符长度
 */
- (BOOL)nx_hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

#pragma mark - GZIP
/**
 *  @brief GZIP压缩
 *  @param level 压缩等级
    取值
    #define Z_NO_COMPRESSION         0
    #define Z_BEST_SPEED             1
    #define Z_BEST_COMPRESSION       9
    #define Z_DEFAULT_COMPRESSION  (-1)
 *  @return 压缩后数据
 */
- (NSData *)gzippedDataWithCompressionLevel:(float)level;

/**
 *  GZIP压缩 压缩等级=-1.0
 *
 *  @return 压缩后数据
 */
- (NSData *)gzippedData;
/**
 *  GZIP解压
 *
 *  @return 解压后数据
 */
- (NSData *)gunzippedData;

@end
