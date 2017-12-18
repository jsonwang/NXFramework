//
//  PLDataSyncMonitor.h
//  Philm
//  数据同步监控
//  Created by zll on 2017/12/18.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 数据同步事件级别
 
 - PLDataSyncEventLevelNormal: 数据同步事件级别
 - PLDataSyncEventLevelFatalError: 数据同步事件级别
 */
typedef NS_ENUM(NSUInteger, PLDataSyncEventLevel) {
    PLDataSyncEventLevelNormal,
    PLDataSyncEventLevelFatalError
};

@interface PLDataSyncMonitor : UIView

@property (nonatomic, copy) NSString *event;                            // 同步事件

- (void)setEvent:(NSString *)event level:(PLDataSyncEventLevel)level;   // 设置事件级别

@end
