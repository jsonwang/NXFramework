//
//  NSDate+NXCategory.m
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NSDate+NXCategory.h"
#import "NXConfig.h"

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key)                                                                            \
    NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo",                                                         \
                                       [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath]                 \
                                                                    stringByAppendingPathComponent:@"NXlib.bundle"]], \
                                       nil)
#endif
@interface NSDate ()
@end

@implementation NSDate (NXCategory)

+ (NSString *)nx_getCurrDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:[NSDate date]];
}
+ (NSString *)nx_getDifferenceDateWithTimeInterval:(NSTimeInterval)secsToBeAdded
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];  // MAC10.8的系统注意“YY”要小写，否则会减一年，iOS暂时不区分
    NSDate *locationdate = [formatter dateFromString:[NSDate nx_getCurrDate]];
    NSDate *predate = [NSDate dateWithTimeInterval:secsToBeAdded sinceDate:locationdate];

    return [formatter stringFromDate:predate];
}

- (NSTimeInterval)nx_timestamp { return [NSDate nx_timestampWithDate:self]; }

+ (NSTimeInterval)nx_timestampWithDate:(NSDate *)date { return [date timeIntervalSince1970]; }

// 返回当前的 NSDateComponents
+ (NSDateComponents *)nx_currentComponentsWithData:(NSDate *)date
{
    NSCalendar *calendar = nil;
    NSUInteger flags = 0;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |
        NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit |
        NSWeekOfYearCalendarUnit;
#else
    calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear;
#endif
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];

    return [calendar components:flags fromDate:date];
}

#pragma mark - 年,月,日,小时,分钟,秒数
- (NSInteger)nx_year { return [NSDate nx_year:self]; }
- (NSInteger)nx_month { return [[NSDate nx_currentComponentsWithData:self] month]; }
- (NSInteger)nx_day { return [[NSDate nx_currentComponentsWithData:self] day]; }
- (NSInteger)nx_hour { return [[NSDate nx_currentComponentsWithData:self] hour]; }
- (NSInteger)nx_minute { return [[NSDate nx_currentComponentsWithData:self] minute]; }
- (NSInteger)nx_second { return [[NSDate nx_currentComponentsWithData:self] second]; }
+ (NSUInteger)nx_year:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] year]; }
+ (NSUInteger)nx_month:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] month]; }
+ (NSUInteger)nx_day:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] day]; }
+ (NSUInteger)nx_hour:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] hour]; }
+ (NSUInteger)nx_minute:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] minute]; }
+ (NSUInteger)nx_second:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] second]; }
#pragma mark - 周几 1,2,3
- (NSInteger)nx_weekOfDay { return [NSDate nx_weekOfDayWithDate:self]; }
+ (NSInteger)nx_weekOfDayWithDate:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] weekday]; }
#pragma mark - 当月是第几周
- (NSInteger)nx_weekOfMonth { return [NSDate nx_weekOfMonthWithDate:self]; }
+ (NSInteger)nx_weekOfMonthWithDate:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] weekOfMonth]; }
#pragma mark - 当年第几周
- (NSInteger)nx_weekOfYear { return [NSDate nx_weekOfYearWithDate:self]; }
+ (NSInteger)nx_weekOfYearWithDate:(NSDate *)date { return [[NSDate nx_currentComponentsWithData:date] weekOfYear]; }
#pragma mark - 取星期的字符串
- (NSString *)nx_weekStr { return [NSDate nx_weekStrWithDate:self]; }
+ (NSString *)nx_weekStrWithDate:(NSDate *)date
{
    NSArray *arrWeek = [NSArray
        arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];

    int week = MIN((int)MAX(0, [NSDate nx_weekOfDayWithDate:date] - 1), (int)(arrWeek.count - 1));

    return [arrWeek objectAtIndex:week];
}
- (NSString *)nx_simplifyWeekStr { return [NSDate nx_simplifyWeekStrWithDate:self]; }
+ (NSString *)nx_simplifyWeekStrWithDate:(NSDate *)date
{
    return [[NSDate nx_weekStrWithDate:date] substringToIndex:3];
}
#pragma mark - 取月份的字符串
- (NSString *)nx_monthStr { return [NSDate nx_monthStrWithDate:self]; }
+ (NSString *)nx_monthStrWithDate:(NSDate *)date
{
    NSArray *arrMonth = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July",
                                                  @"August", @"September", @"October", @"November", @"December", nil];

    int month = MIN((int)MAX(0, [[NSDate nx_currentComponentsWithData:date] month] - 1), (int)arrMonth.count - 1);

    return [arrMonth objectAtIndex:month];
}
- (NSString *)nx_simplifyMonthStr { return [NSDate nx_simplifyMonthStrWithDate:self]; }
+ (NSString *)nx_simplifyMonthStrWithDate:(NSDate *)date
{
    return [[self nx_monthStrWithDate:date] substringToIndex:3];
}

- (NSInteger)nx_numberOfDaysInMonth { return [NSDate nx_numberOfDaysInMonthWithDate:self]; }

+ (NSInteger)nx_numberOfDaysInMonthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange daysRang ;
    
    if (NX_iOS8_OR_LATER)
    {
        daysRang  = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        daysRang  = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
#endif
    }
    
    return daysRang.length;
}

- (BOOL)nx_isLeapYear { return [NSDate nx_isLeapYearWithDate:self]; }

+ (BOOL)nx_isLeapYearWithDate:(NSDate *)date
{
    NSInteger year = date.nx_year;
    if ((0 == year % 4 && 0 != year % 100) || (0 == year % 400))
    {
        return YES;
    }
    return NO;
}

- (NSString *)nx_stringWithFormat:(NSString *)format { return  [NSDate nx_stringWithFormat:format withDate:self]; }

+ (NSString *)nx_stringWithFormat:(NSString *)format withDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
#if !__has_feature(objc_arc)
    [dateFormatter release];
#endif
    return dateString;
}

- (BOOL)nx_isSameDay:(NSDate *)anotherDate { return [NSDate nx_isSameDayWithDate:self anotherDate:anotherDate]; };

+ (BOOL)nx_isSameDayWithDate:(NSDate *)date anotherDate:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1;
    NSDateComponents *components2;
    
    if (NX_iOS8_OR_LATER)
    {
        components1 =
        [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        components2 =
        [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
        
        return ([components1 year] == [components2 year] && [components1 month] == [components2 month] &&
                [components1 day] == [components2 day]);
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        components1 =
        [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        components2 =
        [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
        
        return ([components1 year] == [components2 year] && [components1 month] == [components2 month] &&
                [components1 day] == [components2 day]);
#endif
    }
    
    return NO;
}

/**
 *  @brief 日期相隔多少天
 */
- (NSInteger)nx_daysSinceDate:(NSDate *)anotherDate
{
    return  [NSDate nx_daysSinceDate:anotherDate withDate:self];
}

+ (NSInteger)nx_daysSinceDate:(NSDate *)anotherDate withDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags =0;
    
    if (NX_iOS8_OR_LATER)
    {
        unitFlags= NSCalendarUnitDay;
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        unitFlags= NSDayCalendarUnit;
#endif
    }
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date toDate:anotherDate options:0];
    return [dateComponents day];
}

- (NSString *)nx_timeAgo
{
    return  [NSDate nx_timeAgoWithDate:self];
}

+ (NSString *)nx_timeAgoWithDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([date timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;

    int minutes;

    if (deltaSeconds < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    else if (deltaSeconds < 60)
    {
        return [date stringFromFormat:@"%%d %@seconds ago" withValue:deltaSeconds];
    }
    else if (deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"A minute ago");
    }
    else if (deltaMinutes < 60)
    {
        return [date stringFromFormat:@"%%d %@minutes ago" withValue:deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"An hour ago");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes / 60);
        return [date stringFromFormat:@"%%d %@hours ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes / (60 * 24));
        return [date stringFromFormat:@"%%d %@days ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last week");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes / (60 * 24 * 7));
        return [date stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes / (60 * 24 * 30));
        return [date stringFromFormat:@"%%d %@months ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last year");
    }

    minutes = (int)floor(deltaMinutes / (60 * 24 * 365));
    return [date stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

- (NSString *)stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString *localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];

    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}
- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    //获取当前使用语言 @see
    // http://www.ruanyifeng.com/blog/2008/02/codes_for_language_names.html

    // Russian (ru 俄语)
    if ([NX_CURRENT_LANGUAGE hasPrefix:@"ru"] || [NX_CURRENT_LANGUAGE hasPrefix:@"uk"])
    {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;

        if (Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if (Y > 1 && Y < 5 && (XY < 10 || XY > 20)) return @"_";
        if (Y == 1 && XY != 11) return @"__";
    }

    // Add more languages here, which are have specific translation rules...

    return @"";
}


- (NSString *)nx_getChineseCalendar { return [NSDate nx_getChineseCalendarWithDate:self]; }

+ (NSString *)nx_getChineseCalendarWithDate:(NSDate *)date
{
    NSArray *chineseYears = [NSArray
        arrayWithObjects:@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未",
                         @"壬申", @"癸酉", @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯",
                         @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌", @"丁亥",
                         @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未",
                         @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                         @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥",
                         @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未",
                         @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];

    NSArray *chineseMonths =
        [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月",
                                  @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];

    NSArray *chineseDays = [NSArray
        arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八",
                         @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六",
                         @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四",
                         @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", nil];

    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
                         NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    NSString *y_str = [chineseYears objectAtIndex:localeComp.year - 1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month - 1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day - 1];

    NSString *chineseCal_str = [NSString stringWithFormat:@"%@%@  %@年", m_str, d_str, y_str];

    return chineseCal_str;
}

@end
