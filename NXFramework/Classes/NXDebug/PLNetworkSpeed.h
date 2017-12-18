//
//  PLNetworkSpeed.h
//  NetMonitor
//
//  Created by zll on 2017/12/17.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const kNetworkDownloadSpeedNotification; // 下载速度通知KEY

FOUNDATION_EXTERN NSString *const kNetworkUploadSpeedNotification;   // 上传速度通知KEY

@interface PLNetworkSpeed : NSObject

@property (nonatomic, copy, readonly) NSString * downloadPLNetworkSpeed; // 下载速度

@property (nonatomic, copy, readonly) NSString * uploadPLNetworkSpeed;   // 上传速度

+ (instancetype)shareNetworkSpeed;      // 网速单例

- (void)startMonitoringNetworkSpeed;    // 开始网速监听

- (void)stopMonitoringNetworkSpeed;     // 停止网速监听

@end

