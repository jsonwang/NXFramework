//
//  NXCatonMonitor.m
//  Philm
//
//  Created by AK on 2017/3/27.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXCatonMonitor.h"
#import "NXBacktraceLogger.h"

#import "NXConfig.h"
@interface NXCatonMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@end
@implementation NXCatonMonitor


NXSINGLETON (NXCatonMonitor);

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NXCatonMonitor *moniotr = (__bridge NXCatonMonitor*)info;
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)stop
{
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}


- (void)starWithCallback:(void (^)(NSString *logs))callback;
{
    if (observer)
    {
        return;
    }
    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC));
            
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting)
                {
                    if (++timeoutCount < 5)
                        continue;
                    
                    //打印调用栈信息
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                        NSString * loggers = [NXBacktraceLogger backtraceOfMainThread];
                        NSLog(@"发生卡顿 %@",loggers);
                        
                        //通知UI
                        if (callback)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                callback(loggers);
                            });
                        }
                    });
                 
                }
            }
            timeoutCount = 0;
        }
    });
}

@end
