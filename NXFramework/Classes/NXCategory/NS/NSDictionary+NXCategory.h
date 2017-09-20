//
//  NSDictionary+Error.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NXCategory)

/**
 *  判断不为空
 *
 *  @return YES 为不为空
 */
- (BOOL)nx_isNotEmpty;

/**
 *  取 某个key 对应的数组 value
 *
 *  @param aKey key值
 *  @return 对应数组 没有为nil
 */
- (NSArray *)nx_arrayForKey:(id)aKey;

/**
 *  取 某个key 对应的字典 value
 *
 *  @param aKey key值
 *  @return 对应字典 没有为nil
 */
- (NSDictionary *)nx_dictionaryForKey:(id)aKey;

/**
 *  取 某个key 对应的string value
 *
 *  @param aKey key值
 *  @return 对应string 没有为 @""
 */
- (NSString *)nx_stringForKey:(id)aKey;
/**
 *  取 某个key 对应的value 的NSInteger值
 *
 *  @param aKey key值
 *  @return 对应 NSInteger
 */
- (NSInteger)nx_integerForKey:(id)aKey;
/**
 *  取 某个key 对应的value 的 int 值
 *
 *  @param aKey key值
 *  @return 对应 int
 */
- (int)nx_intForKey:(id)aKey;
/**
 *  取 某个key 对应的value 的 float 值
 *
 *  @param aKey key值
 *  @return 对应 float
 */
- (float)nx_floatForKey:(id)aKey;
/**
 *  取 某个key 对应的value 的 double 值
 *
 *  @param aKey key值
 *  @return 对应 double
 */
- (double)nx_doubleForKey:(id)aKey;

/**
 *  取 某个key 对应的value 的 bool 值
 *
 *  @param aKey key值
 *  @return 对应 bool
 */
- (BOOL)nx_boolForKey:(id)aKey;

/**
 *  拼接dic所有KEY 的值
 *
 *  @return 拼接值 e.g.

    NSDictionary *dic =@{@"a":@"1",@"b":@"2",@"c":@"3"};
    NSLog(@"dic:%@",[dic nx_paramString]); returndic:a=1&b=2&c=3

 */
- (NSString *)nx_paramString;

@end
