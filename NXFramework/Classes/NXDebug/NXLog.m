//
//  NXLog.m
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXLog.h"
#import <asl.h>

static BOOL NX_LOG_SWITCH = NO;

NXLogLevel NXCurrentLogLevel = NXLogLevelInfo;

#ifdef NX_LOG_SWITCH_ON

// set default handler for debug mode
NXLogBlock NXLogHandler =
^(NSUInteger logLevel, NSString *fileName, NSUInteger lineNumber, NSString *methodName, NSString *format, ...) {
    
    
    va_list args;
    va_start(args, format);
    
    NXLogMessagev(logLevel, format, args, fileName, lineNumber, methodName);
    
    va_end(args);
};

#else

// set no default handler for non-DEBUG mode
NXLogBlock NXLogHandler = NULL;

#endif

#pragma mark - Logging Functions

void NXLogSetLoggerBlock(NXLogBlock handler) { NXLogHandler = [handler copy]; }
void NXLogSetLogLevel(NXLogLevel logLevel) { NXCurrentLogLevel = logLevel; }
void NXLogMessagev(NXLogLevel logLevel, NSString *format, va_list args, NSString *fileName, NSUInteger lineNumber,
                   NSString *methodName)
{
    aslmsg msg = asl_new(ASL_TYPE_MSG);
    asl_set(msg, ASL_KEY_READ_UID, "-1");  // without this the message cannot be found by asl_search
    
    // convert to via NSString, since printf does not know %@
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    
    // Unicode全显示为中文
    message = [NSString stringWithCString:[message cStringUsingEncoding:NSASCIIStringEncoding]
                                 encoding:NSNonLossyASCIIStringEncoding];
    
    // Enables XcodeColors (you obviously have to install it too)
    setenv("XcodeColors", "YES", 0);
    //检查有没有安装 xcode colors 插件
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        // XcodeColors is installed and enabled
        
        //@"bg220,0,0;" 设置背景色
        
        // set foreground color
        NSDictionary *foregroundColor = @{
                                          @(NXLogLevelEmergency) : @"fg255,255,255;",
                                          @(NXLogLevelAlert) : @"fg255,255,255;",
                                          @(NXLogLevelCritical) : @"fg139,0,139;",
                                          @(NXLogLevelError) : @"fg220,20,60;",
                                          @(NXLogLevelWarning) : @"fg255,215,0;",
                                          @(NXLogLevelNotice) : @"fg255,255,255;",
                                          @(NXLogLevelInfo) : @"fg255,105,255;",
                                          @(NXLogLevelDebug) : @"fg255,255,255;",
                                          
                                          };
        
        // TODO log uncode string...
        //#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d %s\n",[[[NSString
        // stringWithUTF8String:FILE]
        // lastPathComponent] UTF8String],LINE, [[NSString stringWithFormat:FORMAT,
        // ##VA_ARGS] UTF8String]);
        NSLog(@"%@",
              [NSString stringWithFormat:@"%@%@%@%@", XCODE_COLORS_ESCAPE, [foregroundColor objectForKey:@(logLevel)],
               message, XCODE_COLORS_RESET]);
    }
    else
    {
        NSLog(@"XcodeColors 没有安装 "
              @"https://github.com/jsonwang/"
              @"XcodeColors#option-1-manual-use--custom-macros");
        
        setenv("XcodeColors", "NO", 0);  // Disables XcodeColors
        
        NSLog(@"%@", message);
    }
    
    asl_free(msg);
    
    va_end(args);
}

void NXLogMessage(NXLogLevel logLevel, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    
    NXLogMessagev(logLevel, format, args, @"", 0, @"");
    
    va_end(args);
}

asl_object_t nextMessages(aslresponse *response)
{
    asl_object_t message = NULL;
    aslresponse rep = *response;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    message = asl_next(rep);
#else
    double sv = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sv >= 8.0)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        message = asl_next(rep);
#pragma clang diagnostic pop
        
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        message = aslresponse_next(rep);
#pragma clang diagnostic pop
    }
#endif
    return message;
}

NSArray *NXLogGetMessages(void)
{
    aslmsg query, message;
    int i;
    const char *key, *val;
    
    NSString *facility = [[NSBundle mainBundle] bundleIdentifier];
    
    query = asl_new(ASL_TYPE_QUERY);
    
    // search only for current app messages
    asl_set_query(query, ASL_KEY_FACILITY, [facility UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse response = asl_search(NULL, query);
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    while ((message = nextMessages(&response)))
    {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        
        for (i = 0; ((key = asl_key(message, i))); i++)
        {
            NSString *keyString = [NSString stringWithUTF8String:(char *)key];
            
            val = asl_get(message, key);
            
            NSString *string = val ? [NSString stringWithUTF8String:val] : @"";
            [tmpDict setObject:string forKey:keyString];
        }
        
        [tmpArray addObject:tmpDict];
    }
    asl_free(query);
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    asl_release(response);
#else
    double sv = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sv >= 8.0)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        asl_release(response);
#pragma clang diagnostic pop
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        aslresponse_free(response);
#pragma clang diagnostic pop
    }
#endif
    
    if ([tmpArray count])
    {
        return [tmpArray copy];
    }
    
    return nil;
}

@implementation NXLog

#pragma mark - 自定义打印开关
+ (void)setLogEnabled:(BOOL)isEnable
{
    NX_LOG_SWITCH = isEnable;
}

+ (BOOL)logEnable
{
    return NX_LOG_SWITCH;
}

@end

