//
//  NXCatonMonitor.h
//  Philm
//
//  Created by AK on 2017/3/27.
//  Copyright © 2017年 yoyo. All rights reserved.
//

/*
    监控卡顿
 */

#import <Foundation/Foundation.h>

@interface NXCatonMonitor : NSObject


//初始化

/**
 实例方法

 @return 实例对象
 */
+ (NXCatonMonitor *)sharedInstance;

/**
 开始监控

 @param callback 返回堆栈信息
 */
- (void)starWithCallback:(void (^)(NSString *logs))callback;


/**
 停止监控
 */
- (void)stop;

@end
