//
//  NSDate+NXCategory.h
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#define kNXFW_SECOND_MINUTE 60
#define kNXFW_SECOND_HOUR 3600
#define kNXFW_SECOND_DAY 86400
#define kNXFW_SECOND_WEEK 604800
#define kNXFW_SECOND_YEAR 31556926

@interface NSDate (NXCategory)

/**
 *  取 [NSDate date] 的年月日
 *
 *  @return 年月日str e.g. 2016-09-02
 */
+ (NSString *)nx_getCurrDate;

/**
 *  计算和[NSDate date] 相差多少S 的日期
 *
 *  @param secsToBeAdded 相差秒数 e.g. 明天:24 * 60 * 60 , 昨天:-24 * 60 * 60
 *
 *  @return 预计日期 YYYY-MM-dd
 */
+ (NSString *)nx_getDifferenceDateWithTimeInterval:(NSTimeInterval)secsToBeAdded;

/**
 *  按指定data 返回 NSDateComponents
 *
 *  @param data 指定日期
 *
 *  @return NSDateComponents
 */
+ (NSDateComponents *)nx_currentComponentsWithData:(NSDate *)data;

/**
 *  取当前时间戳
 *
 *  @return 时间戳 e.g. 1472829997
 */
- (NSTimeInterval)nx_timestamp;

/**
 *  取指定日期的 时间戳
 *
 *  @param date 指定日期
 *
 *  @return 时间戳 e.g. 1472829997
 */
+ (NSTimeInterval)nx_timestampWithDate:(NSDate *)date;

#pragma mark -
/**
 *
 * @return 当前时间的,年,月,日,小时,分钟,秒数
 */
- (NSInteger)nx_year;
- (NSInteger)nx_month;
- (NSInteger)nx_day;
- (NSInteger)nx_hour;
- (NSInteger)nx_minute;
- (NSInteger)nx_second;

/**
 * @param date 指定时间
 * @return 指定时间的,年,月,日,小时,分钟,秒数
 */
+ (NSUInteger)nx_year:(NSDate *)date;
+ (NSUInteger)nx_month:(NSDate *)date;
+ (NSUInteger)nx_day:(NSDate *)date;
+ (NSUInteger)nx_hour:(NSDate *)date;
+ (NSUInteger)nx_minute:(NSDate *)date;
+ (NSUInteger)nx_second:(NSDate *)date;

/**
 *  获取当前日期是星期几
 *
 *  @return 星期
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)nx_weekOfDay;

/**
 *  获取指定日期是星期几
 *  @param date  指定日期
 */
+ (NSInteger)nx_weekOfDayWithDate:(NSDate *)date;


/**
 *  取当前是 当月的第几周
 *
 */
- (NSInteger)nx_weekOfMonth;

/**
 *  获取指定日期是 当月的第几周
 *  @param date  指定日期
 */
+ (NSInteger)nx_weekOfMonthWithDate:(NSDate *)date;

/**
 *  取当前日期是 当年的第几周
 *
 */
- (NSInteger)nx_weekOfYear;

/**
 *  指定日期是 当年的第几周
 *
 *  @param date  指定日期
 */
+ (NSInteger)nx_weekOfYearWithDate:(NSDate *)date;

/**
 *  当前日期星期string(全写)  
 *
 *  @return 星期 e.g. Sunday
 */
- (NSString *)nx_weekStr;

/**
 *  指定日期星期string(全写)
 *
 *  @param date  指定日期
 *  @return 星期 e.g. Sunday
 */
+ (NSString *)nx_weekStrWithDate:(NSDate *)date;
/**
 *  当前日期星期string(缩写)
 *
 *  @return 星期 e.g. Sun
 */
- (NSString *)nx_simplifyWeekStr;
/**
 *  指定日期的星期string(缩写)
 *
 *  @param date  指定日期
 *  @return 星期 e.g. Sun
 */
+ (NSString *)nx_simplifyWeekStrWithDate:(NSDate *)date;

/**
 *  当前日期月份string(全写)
 *
 *  @return 月份 e.g. January
 */
- (NSString *)nx_monthStr;

/**
 *  指定日期的月份string(全写)
 *
 *  @param date  指定日期
 *  @return 月份 e.g. January
 */
+ (NSString *)nx_monthStrWithDate:(NSDate *)date;

/**
 *  当前日期月份string(缩写)
 *
 *  @return 月份 e.g. Jan
 */
- (NSString *)nx_simplifyMonthStr;
/**
 *  指定日期月份string(缩写)
 *
 *  @param date  指定日期
 *  @return 月份 e.g. Jan
 */
+ (NSString *)nx_simplifyMonthStrWithDate:(NSDate *)date;

/**
 *  获取当前月份的天数
 *
 *  @return 天数 e.g. 30
 */
- (NSInteger)nx_numberOfDaysInMonth;

/**
 *  获取指定月份的天数
 *
 *  @param date  指定日期
 *  @return 天数 e.g. 30
 */
+ (NSInteger)nx_numberOfDaysInMonthWithDate:(NSDate *)date;

/**
 *  判断当前是否是闰年
 *
 *  @return 返回YES 闰年; NO 平年
 */
- (BOOL)nx_isLeapYear;
/**
 *  判断指定日期是否是闰年
 *
 *  @param date  指定日期
 *  @return 返回YES 闰年; NO 平年
 */
+ (BOOL)nx_isLeapYearWithDate:(NSDate *)date;

/**
 *  当前时间按指定格式转字符串
 *  　NSDateFormatter 格式化参数如下：
     G: 公元时代，例如AD公元
     yy: 年的后2位
     yyyy: 完整年
     MM: 月，显示为1-12
     MMM: 月，显示为英文月份简写,如 Jan
     MMMM: 月，显示为英文月份全称，如 Janualy
     dd: 日，2位数表示，如02
     d: 日，1-2位显示，如 2
     EEE: 简写星期几，如Sun
     EEEE: 全写星期几，如Sunday
     aa: 上下午，AM/PM
     H: 时，24小时制，0-23
     K：时，12小时制，0-11
     m: 分，1-2位
     mm: 分，2位
     s: 秒，1-2位
     ss: 秒，2位

     S: 毫秒
     常用日期结构：
     yyyy-MM-dd HH:mm:ss.SSS
     yyyy-MM-dd HH:mm:ss
     yyyy-MM-dd
     MM dd yyyy


 Also when using a date format string using the correct format is important.

 @"YYYY" is week-based calendar year.

 @"yyyy" is ordinary calendar year.

 *  @param format 时间格式 YYYY-MM-dd hh:mm:ss
 *
 *  @return 转换后字符 2016-09-02 04:06:06
 */
- (NSString *)nx_stringWithFormat:(NSString *)format;

/**
 * 指定时间按指定格式转字符串
 *  @param format 时间格式 YYYY-MM-dd hh:mm:ss
 *  @param date  指定日期
 *  @return 转换后字符 2016-09-02 04:06:06
 */
+ (NSString *)nx_stringWithFormat:(NSString *)format withDate:(NSDate *)date ;


/**
 *  判断某个时间 和 当前时间 是否是同一天
 *
 *  @param anotherDate 比对date
 *
 *  @return YES为同一天
 */
- (BOOL)nx_isSameDay:(NSDate *)anotherDate;

/**
 *  判断两个时间 是否是同一天
 *
 *  @param date 指定时间
 *  @param anotherDate 比对date
 *
 *  @return YES为同一天
 */
+ (BOOL)nx_isSameDayWithDate:(NSDate *)date anotherDate:(NSDate *)anotherDate;

/**
 *  某个日期 与 当前日期 相隔多少天
 *
 *  @param anotherDate 比对date
 *
 *  @return 相隔天数
 */
- (NSInteger)nx_daysSinceDate:(NSDate *)anotherDate;
/**
 *  两个日期相隔多少天
 *
 *  @param anotherDate 比对date
 *  @param date 指定时间
 *
 *  @return 相隔天数
 */
+ (NSInteger)nx_daysSinceDate:(NSDate *)anotherDate withDate:(NSDate *)date;

/**
 *  当前时间(self) 与 [NSDate date] 时间间隔str ,支持英文和简体中文
 *
 *  @return e.g. < 5min Just now
 */
- (NSString *)nx_timeAgo;

/**
 *  指定时间 与 [NSDate date] 时间间隔str ,支持英文和简体中文
 *
 *  @param date 指定时间
 *  @return e.g. < 5min Just now
 */
+ (NSString *)nx_timeAgoWithDate:(NSDate *)date;

/**
 * 当前日期的农历
 * @return 农历日期
 */
- (NSString *)nx_getChineseCalendar ;

/**
 * 指定日期的中国农历日期
 *
 * @param date 指定日期
 * @return 农历日期
 */
+ (NSString *)nx_getChineseCalendarWithDate:(NSDate *)date;

@end
