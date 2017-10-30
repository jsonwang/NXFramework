//
//  NSString+Extensions.h
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NXCategory)

/**
 *  判断字符串是不是 为空
 *
 *  @param string 要判断的字符串
 *
 *  @return 如果 是为空 & <null> & (null) 返回YES
 */
+ (BOOL)nx_isBlankString:(NSString *)string;

/**
 *  通过字节取到文件大小
 *  e.g.
 *  [NSString nx_formatByteCount:1024*10]; 10 KB
 *  @param bytes 字节数
 *
 *  @return 文件大小
 */
+ (NSString *)nx_formatByteCount:(long long)bytes;

/**
 Method to get the recommended MIME-Type for the given file extension. If no
 MIME-Type can be determined then
 'application/octet-stream' is returned.
 @param extension the file extension
 @return the recommended MIME-Type for the given path extension.
 */
+ (NSString *)nx_MIMETypeForFileExtension:(NSString *)extension;

/**
 Method to get the official description for a given file extension.
 @param extension the file extension
 @return the description
 */
+ (NSString *)nx_fileTypeDescriptionForFileExtension:(NSString *)extension;

/**
 Method to get the preferred UTI for a given file extension.
 @param extension the file extension
 @return the UTI
 */
+ (NSString *)nx_universalTypeIdentifierForFileExtension:(NSString *)extension;

/**
 Get the prefered file extension for a given UTI.
 @param UTI he UTI
 @returns The File Extension
 */
+ (NSString *)nx_fileExtensionForUniversalTypeIdentifier:(NSString *)UTI;

/**
 计算指定字符串的字符数

 @param string 指定字符串
 @return 字符数
 */
+ (int)nx_countWords:(NSString *)string;

/**
 截取字符串  中文最多10  英文最多20

 @param string 指定字符串
 @return 截取后的字符串
 */
+ (NSString *)nx_clipContentTextToLimit:(NSString *)string;



/**
 是否是纯数字
 
 @param str 字符串
 @return 是否是纯数字
 */
+ (BOOL)isNumText:(NSString *)str;

/**
 *  判断是不是回文字符串
 *   e.g.
 *   [@"HANNAH" isPalindrome];  returns YES
 *   [@"CLAUDE" isPalindrome];  returns NO
 *  @return 判断结果
 */
- (BOOL)nx_isPalindrome;

/**
 *  字符串取反
 *  e.g.
 *      NSString *testString = @"abc";
 *      NSString *testReversed = [testString reverse]; // @"cba"
 *  @return 取反串
 */
- (NSString *)nx_reverse;

/**
 *  str to nsnumber
 *
 *  @return nsnumber
 */
- (NSNumber *)nx_stringToNSNumber;

/**
 Tests if the receiver conforms to a given UTI.
 @param conformingUTI the UTI that is tested against
 @return `YES` if the receiver conforms
 */
- (BOOL)nx_conformsToUniversalTypeIdentifier:(NSString *)conformingUTI;

/**
 @returns `YES` if the receiver is a movie file name
 */
- (BOOL)nx_isMovieFileName;

/**
 @Returns `YES` if the receiver is an audio file name
 */
- (BOOL)nx_isAudioFileName;

/**
 @Returns `YES` if the receiver is an image file name
 */
- (BOOL)nx_isImageFileName;

/**
 @Returns `YES` if the receiver is an HTML file name
 */
- (BOOL)nx_isHTMLFileName;

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param width 约束高度
 */
- (CGSize)nx_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param height 约束宽度
 */
- (CGFloat)nx_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)nx_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/**
 *  判断是否为合法URL 判断方式: 用正则 判断是不是以 (http|https):// 开头
 *
 *  @return YES 合法
 */
- (BOOL)nx_isValidateUrl;

/**
 *  URL编码 @see
 https://developer.apple.com/library/mac/documentation/CoreFoundation/Reference/CFURLRef/
 alse see stringByAddingPercentEscapesUsingEncoding
 *
 *  @return 编码后的URL
 */
- (NSString *)nx_URLEncoded;

/**
 *  string 转成 json格式数据
 *
 *  @return 转换后的结果人可能是 NSDictionary | NSArray
 */
- (id)nx_jsonValue;

/**
 *  add by ak xxx  不能使用 containsstring IOS8.0才能使用
 *
 *  @param other 包含的字符串
 *
 *  @return YES 是包含
 */
- (BOOL)nx_containsString:(NSString *)other;

#pragma mark - 加解密
/*
   e.g.
     NSString *msg = @"123456789";
     NSLog(@"base64加密:%@----%@",[msg nx_base64Encoded],[[msg nx_base64Encoded]
   nx_base64Decoded]);
     NSLog(@"SHA1:%@",[msg nx_sha1]);
     NSLog(@"MD5:%@",[msg nx_md5HexDigest]);

   out:
    base64加密:MTIzNDU2Nzg5----123456789
    SHA1:f7c3bc1d808e04732adf679965ccc34ca7ae3441
    MD5:25f9e794323b453885f5181f1b624d0b

 */

- (NSString *)nx_sha1;
- (NSString *)nx_md5HexDigest;

//@see http://www.jianshu.com/p/b8a5e1c770f9
- (NSString *)nx_base64Encoded;
- (NSString *)nx_base64Decoded;

@end
