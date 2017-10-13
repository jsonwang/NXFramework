//
//  NXLog.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/**

//#define NXDEVELOPMENT_ENVIRONMENT

  注意XXXX 如果 定义了 NXDEVELOPMENT_ENVIRONMENT 这个宏 就打印LOG 在relese
时注意关闭LOG
 e.g. NXLogWarning(@"warning" @"info");


 There is a macro for each ASL log level:

 - NXLogEmergency (0)
 - NXLogAlert (1)
 - NXLogCritical (2)
 - NXLogError (3)
 - NXLogWarning (4)
 - NXLogNotice (5)
 - NXLogInfo (6)
 - NXLogDebug (7)

 */

#import <Foundation/Foundation.h>

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"fg;"  // Clear any foreground color
#define XCODE_COLORS_RESET_BG XCODE_COLORS_ESCAPE @"bg;"  // Clear any background color
#define XCODE_COLORS_RESET XCODE_COLORS_ESCAPE @";"       // Clear any foreground or background color

/**
 Replacement for `NSLog` which can be configured to output certain log levels at
 run time.
 */

// block signature called for each log statement
typedef void (^NXLogBlock)(NSUInteger logLevel, NSString *fileName, NSUInteger lineNumber, NSString *methodName,
                           NSString *format, ...);

// internal variables needed by macros
extern NXLogBlock NXLogHandler;
extern NSUInteger NXCurrentLogLevel;

/**
 Constants for log levels used by NXLog
 */
typedef NS_ENUM(NSUInteger, NXLogLevel) {
    /**
     Log level for *emergency* messages
     */
    NXLogLevelEmergency = 0,

    /**
     Log level for *alert* messages
     */
    NXLogLevelAlert = 1,

    /**
     Log level for *critical* messages
     */
    NXLogLevelCritical = 2,

    /**
     Log level for *error* messages
     */
    NXLogLevelError = 3,

    /**
     Log level for *warning* messages
     */
    NXLogLevelWarning = 4,

    /**
     Log level for *notice* messages
     */
    NXLogLevelNotice = 5,

    /**
     Log level for *info* messages. This is the default log level for NXLog.
     */
    NXLogLevelInfo = 6,

    /**
     Log level for *debug* messages
     */
    NXLogLevelDebug = 7
};

/**
 @name Logging Functions
 */

/**
 Sets the block to be executed for messages with a log level less or equal the
 currently set log level
 @param handler The block to handle log output
 */
void NXLogSetLoggerBlock(NXLogBlock handler);

/**
 Modifies the current log level
 @param logLevel The ASL log level (0-7) to set, lower numbers being more
 important
 */
void NXLogSetLogLevel(NSUInteger logLevel);

/**
 Variant of NXLogMessage that takes a va_list.
 @param logLevel The NXLogLevel for the message
 @param format The log message format
 @param args The va_list of arguments
 */
void NXLogMessagev(NXLogLevel logLevel, NSString *format, va_list args, NSString *fileName, NSUInteger lineNumber,
                   NSString *methodName);

/**
 Same as `NSLog` but allows for setting a message log level
 @param logLevel The NXLogLevel for the message
 @param format The log message format and optional variables
 */
void NXLogMessage(NXLogLevel logLevel, NSString *format, ...);

/**
 Retrieves the log messages currently available for the running app
 @returns an `NSArray` of `NSDictionary` entries
 */
NSArray *NXLogGetMessages(void);

/**
 @name Macros
 */

// log macro for error level (0)
#define NXLogEmergency(format, ...) NXLogCallHandlerIfLevel(NXLogLevelEmergency, format, ##__VA_ARGS__)

// log macro for error level (1)
#define NXLogAlert(format, ...) NXLogCallHandlerIfLevel(NXLogLevelAlert, format, ##__VA_ARGS__)

// log macro for error level (2)
#define NXLogCritical(format, ...) NXLogCallHandlerIfLevel(NXLogLevelCritical, format, ##__VA_ARGS__)

// log macro for error level (3)
#define NXLogError(format, ...) NXLogCallHandlerIfLevel(NXLogLevelError, format, ##__VA_ARGS__)

// log macro for error level (4)
#define NXLogWarning(format, ...) NXLogCallHandlerIfLevel(NXLogLevelWarning, format, ##__VA_ARGS__)

// log macro for error level (5)
#define NXLogNotice(format, ...) NXLogCallHandlerIfLevel(NXLogLevelNotice, format, ##__VA_ARGS__)

// log macro for info level (6)
#define NXLogInfo(format, ...) NXLogCallHandlerIfLevel(NXLogLevelInfo, format, ##__VA_ARGS__)

// log macro for debug level (7)
#define NXLogDebug(format, ...) NXLogCallHandlerIfLevel(NXLogLevelDebug, format, ##__VA_ARGS__)

// macro that gets called by individual level macros
#define NXLogCallHandlerIfLevel(logLevel, format, ...) \
    if (NXLogHandler && NXCurrentLogLevel >= logLevel) \
    NXLogHandler(logLevel, NXLogSourceFileName, NXLogSourceLineNumber, NXLogSourceMethodName, format, ##__VA_ARGS__)

// helper to get the current source file name as NSString
#define NXLogSourceFileName [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

// helper to get current method name
#define NXLogSourceMethodName [NSString stringWithUTF8String:__FUNCTION__]

// helper to get current line number
#define NXLogSourceLineNumber __LINE__

@interface NXLog : NSObject

#pragma mark - 自定义打印开关
/**
 设置是否打印sdk的log信息, 默认NO(不打印log).
 
 @param isEnable YES 显示
 */
+ (void)setLogEnabled:(BOOL)isEnable;

/**
 返回当前开关状态
 
 @return YES 是打印 log
 */
+ (BOOL)logEnable;

@end


