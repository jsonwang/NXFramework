//
//  NSBundle+NXFramework.h
//  Pods-NXFramework_Example
//
//  Created by liuming on 2017/11/14.
//

#import <Foundation/Foundation.h>

@interface NSBundle (NXCategory)

/**
 读取NXFrameworkBundle下资源路径

 @param name 资源name
 @param type 资源type
 @return 返回资源路径
 */
+(NSString *)nx_pathForResource:(NSString *)name ofType:(NSString *)type;

/**
 读取NXFrameworkBundle下的国际化文案

 @param key 文案key
 @param value value
 @return 获取的国际化文案值
 */
+ (NSString *)nx_localizedStringForKey:(NSString *)key value:(NSString *)value;

/**
 读取NXFrameworkBundle下的国际化文案

 @param key 文案key
 @param value value
 @param talbelName 指定域
 @return 获取的国际化文案值
 */
+ (NSString *)nx_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)talbelName;
@end

