//
//  NXKeychainTools.h
//  NXlib
//
//  Created by AK on 14-5-18.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/**
 *  保存数据 到钥匙串中
 *
 *
 *
 */
#import <Foundation/Foundation.h>

@interface NXKeychainTools : NSObject
{
}

/**
 *  从钥匙串取数据
 *
 *  @param keyString 数据KEY
 *  @param error     错误信息
 *
 *  @return 返回储存数据 如果返回 @"" 指没有值
 */
+ (NSString *)getStringFromKeychainForKey:(NSString *)keyString error:(NSError **)error;

/**
 *  保存数据到钥匙串
 *
 *  @param keyString      数据KEY
 *  @param savaDataString 保存的字符串
 *  @param updateExisting 如果存在是否更新
 *  @param error          错误信息
 *
 *  @return 保存数据结果 YES 成功 ,NO 不成功
 */
+ (BOOL)saveStringToKeychainWithKeyString:(NSString *)keyString
                           saveDataString:(NSString *)savaDataString
                           updateExisting:(BOOL)updateExisting
                                    error:(NSError **)error;
/**
 *  删除数据
 *
 *  @param keyString 数据KEY
 *  @param error     错误信息
 *
 *  @return 删除数据如果 YES成功, NO 不成功
 */
+ (BOOL)deleteStringFromKeychain:(NSString *)keyString error:(NSError **)error;

@end
