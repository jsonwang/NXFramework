//
//  NXLogManager.m
//  Philm
//
//  Created by AK on 2017/2/24.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXLogManager.h"

@implementation NXLogManager

// 将NSlog打印信息保存到Document目录下的文件中
+ (void)redirectNSlogToDocumentFolder
{
    //日志所有文件目录
    NSString *logFilePath = [NXLogManager getLogFilePath];
    unlink([logFilePath UTF8String]);
    [NXFileManager createFileAtPath:logFilePath];
 
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

+ (NSString *)getLogFilePath
{
    //日志所有文件目录
    NSString *foldPath =  [NSString stringWithFormat:@"%@/appLog/nx_log.txt",[NXFileManager getDocumentDir]];
 
    return foldPath;
}

@end
