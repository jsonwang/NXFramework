//
//  SCDateManager.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXDateManager : NSObject

+ (NXDateManager *)sharedInstance;


/**
 将某个时间 按照指定格式 转化为字符串

 @param date 指定时间
 @param format 格式
 @return 时间字符串
 */
- (NSString *)stringByConvertFromDate:(NSDate *)date format:(NSString *)format;


/**
 将字符串 转化为时间

 @param string 时间字符串
 @param format 格式
 @return 时间
 */
- (NSDate *)dateByConvertFromString:(NSString *)string format:(NSString *)format;

/**
  将时间间隔 转化为字符串

 @param secs 时间间隔
 @param format 格式
 @return 时间字符串
 */
- (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)secs format:(NSString *)format;

@end
