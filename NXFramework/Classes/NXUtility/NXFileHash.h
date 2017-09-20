//
//  NXFileHash.h
//  NXlib
//
//  Created by AK on 16/4/26.
//  Copyright © 2016年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  读取 文件的校验值 MD5 ,sha1, sha512 值
 *  e.g.
 *  NSString * executablePath = [[NSBundle mainBundle] executablePath];
 *	NSString * executableFileMD5Hash = [FileHash
 *md5HashOfFileAtPath:executablePath];
 *
 */

@interface NXFileHash : NSObject

/**
 *  文件的 MD5
 *
 *  @param filePath 文件路径
 *
 *  @return MD5值
 */
+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath;

/**
 *  文件的 sha1 值
 *
 *  @param filePath 文件路径
 *
 *  @return sha1 值
 */
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
/**
 *   文件的 sha512 值
 *
 *  @param filePath 文件路径
 *
 *  @return sha512 值
 */
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;

@end
