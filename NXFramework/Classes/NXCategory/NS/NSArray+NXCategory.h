//
//  NSArray+FirstObject.h
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NXCategory)

/**
 *  判断不为空
 *
 *  @return YES 为不为空
 */
- (BOOL)nx_isNotEmpty;

/**
 *  数组排序 注意数组里的元素只能为NSNumber
 *
 e.g.

    NSArray *test = @[ @"1", @"100", @"26" ];
    NSLog(@"排序后数组: %@", [test nx_sortNumArray]); (1,26,100)

 *
 *  @return 排序后数组
 */
- (NSArray *)nx_sortNumArray;

/**
 *  去掉重复元素
 *  e.g.
 `
    NSArray *test = @[ @"1", @"26", @"26" ];
    NSLog(@"去重后数组: %@", [test nx_getUnduplicatedElement]); (1,26)
 `
 *
 *  @return 去重后数组
 */
- (NSArray *)nx_getUnduplicatedElement;

/**
 *  数组倒序

 e.g.
    NSArray *test = @[ @"a", @"b", @"c" ];
    NSLog(@"逆序后数组: %@", [test nx_reverseArray]); (c,b, a )
 *
 *
 *  @return 逆序后数组
 */
- (NSArray *)nx_reverseArray;

/**
 *  数组中包含某字符串
 *
 *  @param string 查询字符串
 *
 *  @return YES为包含
 */
- (BOOL)nx_isContainsString:(NSString *)string;

@end
