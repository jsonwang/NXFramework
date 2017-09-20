//
//  QYMonitorTool.h
//  MonitorTool
//
//  Created by liuming on 16/9/30.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXDMItemModel.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NXMonitorLevel)
{
    NXMonitorLevelOfNormal,         //正常
    NXMonitorLevelOfWrarning,       //警告
    NXMonitorLevelBad,              //严重
};

@class NXMonitorTool;
@protocol QYMonitorToolDelegate<NSObject>

- (void)monitor:(NXMonitorTool *)monitor category:(QYMonitorCategory)category data:(NSString *)data;

- (void)monitor:(NXMonitorTool *)monitor level:(NXMonitorLevel) level category:(QYMonitorCategory)category;

@end

@interface NXMonitorTool : NSObject

@property(nonatomic, assign) id<QYMonitorToolDelegate> delegate;


- (UIColor *)monitorColor:(NXMonitorLevel) level;

- (NSArray *)getMonitors;

- (void)startMonitor;

- (void)freeTimer;

- (void)archivedViewRect:(CGRect)rect forKey:(NSString *)key;

- (CGRect)unArchivedViewRectForKey:(NSString *)key;
@end
