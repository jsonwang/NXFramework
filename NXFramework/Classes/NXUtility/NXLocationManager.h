//
//  SCLocationManager.h
//  NXlib
//
//  Created by AK on 14/10/20.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

/**
 * TODO:
 *      iOS8及以上使用位置服务需要在Info.plist文件中
 *      NSLocationWhenInUseUsageDescription &
 *      NSLocationAlwaysUsageDescription
 *      两个字段, 值可以为空.
 */

/**
 *  位置访问权限认证类型
 */
typedef NS_ENUM(NSUInteger, CLLocationManagerAuthorizationType) {
    /**
     *  使用期间使用位置
     */
    CLLocationManagerAuthorizationTypeWhenInUse,
    /**
     *  始终使用位置
     */
    CLLocationManagerAuthorizationTypeAlways,
} NS_ENUM_AVAILABLE_IOS(8_0);

@interface CLLocationManager (NXLocationManager)

/**
 *  @brief  位置访问权限认证类型
 *
 *  Discussion:
 *      By default, CLLocationManagerAuthorizationTypeWhenInUse is used.
 */
@property(nonatomic) CLLocationManagerAuthorizationType authorizationType NS_AVAILABLE_IOS(8_0);

@end

/**
 *  @brief  定位完成操作
 *
 *  @param locations 位置数组
 */
typedef void (^NXLocationManagerDidUpdateHandler)(NSArray *locations);

/**
 *  @brief  定位失败操作
 *
 *  @param error 错误信息
 */
typedef void (^NXLocationManagerDidFailHandler)(NSError *error);

/**
 *  @brief  定位配置操作
 *
 *  @param manager 定位管理类
 */
typedef void (^NXLocationManagerConfigHandler)(CLLocationManager *manager);

@interface NXLocationManager : NSObject

/**
 *  @brief  定位完成时停止更新位置
 *
 *  Discussion:
 *      By default, YES.
 */
@property(nonatomic, assign) BOOL stopWhenDidUpdate;

/**
 *  @brief  定位失败时停止更新位置
 *
 *  Discussion:
 *      By default, YES.
 */
@property(nonatomic, assign) BOOL stopWhenDidFail;

/**
 *  @brief  定位失败时显示提示警告
 *
 *  Discussion:
 *      By default, YES.
 */
@property(nonatomic, assign) BOOL alertWhenDidFail;

+ (NXLocationManager *)sharedInstance;

/*
 * 开始定位
 * didUpdateHandler 位置更新回调
 * didFailHandler 定位失败回调
 */
- (void)startLocateWithConfig:(NXLocationManagerConfigHandler)configHandler
                    didUpdate:(NXLocationManagerDidUpdateHandler)didUpdateHandler
                      didFail:(NXLocationManagerDidFailHandler)didFailHandler;

@end
