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
 
 - NXDataSyncEventLevelNormal: 数据同步事件级别
 - NXDataSyncEventLevelFatalError: 数据同步事件级别
 */
typedef NS_ENUM(NSUInteger, NXDataSyncEventLevel) {
    NXDataSyncEventLevelNormal,
    NXDataSyncEventLevelFatalError
};

@interface NXDataSyncMonitor : UIView

@property (nonatomic, copy) NSString *event;                            // 同步事件

- (void)setEvent:(NSString *)event level:(NXDataSyncEventLevel)level;   // 设置事件级别

@end
