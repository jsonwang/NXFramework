//
//  NXBacktraceLogger.h
//  Philm
//
//  Created by AK on 2017/3/27.
//  Copyright © 2017年 yoyo. All rights reserved.
//

/*
    打印堆栈信息
 */
#import <Foundation/Foundation.h>

@interface NXBacktraceLogger : NSObject

/**
 打印所有线程

 @return 所有线程信息
 */
+ (NSString *)backtraceOfAllThread;

//

/**
 打印当前线程

 @return 当前线程信息
 */
+ (NSString *)backtraceOfCurrentThread;


/**
  打印主线程

 @return 主线程信息
 */
+ (NSString *)backtraceOfMainThread;


/**
 打印指定线程

 @param thread 指定线程
 @return 指定线程信息
 */
+ (NSString *)backtraceOfNSThread:(NSThread *)thread;


@end
