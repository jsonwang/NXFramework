//
//  NXDevicePermission.h
//  AKImovie
//
//  Created by AK on 16/3/16.
//  Copyright © 2016年 ak. All rights reserved.
//

/*判断设置权限受权情况

 不要用 Wi-Fi — prefs:root=WIFI 这种方式打开设置界面 会被拒
 XXXX 想办法处理 设置完权限后 在回到自己的APP 应用会重新启动问题


 ALAuthorizationStatusNotDetermined = 0, 用户尚未做出了选择这个应用程序的问候
 ALAuthorizationStatusRestricted,
 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
 ALAuthorizationStatusDenied, 用户已经明确否认了这一照片数据的应用程序访问.
 ALAuthorizationStatusAuthorized         用户已授权应用访问照片数据.


 */

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface NXDevicePermission : NSObject

/**
 *  自动跳转到 设置界面 IOS 8.0以后才能使用
 */
+ (void)autoJumpSetting NS_AVAILABLE_IOS(8_0);

/**
 *  检测是否允许访问相机
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowCamera;

#pragma mark - 相册
/**
 *  检测是否允许访问手机相册
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowPhotoAlbum;

+ (void)requestPhotosAccessWithOperationBlock:(void (^)(BOOL granted))block;

/**
 *  请求相册权限
 *
 *  @return 执行结果 YES OR NO
 */
+ (BOOL)requestPhotosAccess;

#pragma mark - 麦克风
/**
 *  检测是否允许访问麦克风
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowDeviceMicophone;

/**
 *  请求麦克风权限
 */
+ (void)requestMicrophoneAccessWithOperationBlock:(void (^)(BOOL granted))block;
+ (void)requestMicrophoneAccess;

/**
 *  检测设备是否处于静音模式
 *
 *  @return YES 允许
 */
+ (BOOL)isSilenced;

#pragma mark - 地理位置

/**
 *  检测是否允许使用定位服务
 *
 *  @return 结果
 */
+ (BOOL)isAllowLocaiton;
/**
 *
 *  检测 当前应用程序是否允许定位服务
 *  @return 结果
 */
+ (CLAuthorizationStatus)appIsAllowLocation;
#pragma mark - 通信录
/**
 *  检测是否允许访问通信录
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowAddressBook;

#pragma mark - 蓝牙
/**
 *  检测是否允许访问蓝牙
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowBluetooth;

#pragma makr - 第三方账号

/**
 *  检测是否允许访问第三方账号权限
 *
 *  @param accountTypeIndentifier 第三方账号 类型
    ACAccountTypeIdentifierTwitter
    ACAccountTypeIdentifierFacebook
    ACAccountTypeIdentifierSinaWeibo
    ACAccountTypeIdentifierTencentWeibo
    ACAccountTypeIdentifierLinkedIn
 *
 *  @return YES 允许
 */
+ (BOOL)isAllowSocialAccountAuthorizationStatus:(NSString *)accountTypeIndentifier;

/**
 *  请求第三方账号权限
 *
 *  @param accountTypeIndentifier  第三方账号 类型
    ACAccountTypeIdentifierTwitter
    ACAccountTypeIdentifierFacebook
    ACAccountTypeIdentifierSinaWeibo
    ACAccountTypeIdentifierTencentWeibo
    ACAccountTypeIdentifierLinkedIn
 */
+ (void)requestSocialAccountAuthor:(NSString *)accountTypeIndentifier complent:(void(^)(BOOL granted, NSError *error)) block;

#pragma mark - 日历
/**
 *  检测是否允许访问日历
 *
 *  @param type
    EKEntityTypeEvent,
    EKEntityTypeReminder
 *
 *  @return YES 允许
 */
+ (BOOL)isAlloEventStoreAccessForType:(EKEntityType)type;

/**
 *  请求日历权限
 *
 *  @param type
    EKEntityTypeEvent,
    EKEntityTypeReminder
 */
+ (void)requestEventStoreAccessWithType:(EKEntityType)type;
/**
 *  请求相册权限
 */
+ (void)requestCameraAccess;
/**
 *  请求相册权限
 *
 *  @param block 回掉block
 */
+ (void)requestCameraAccessWithOperationBlock:(void (^)(BOOL granted))block;
#pragma makr - Advertising
/**
 *  检测是否允许访问广告标示符
 *
 *  @return  YES 允许
 */
+ (BOOL)advertisingIdentifierStatus;

/**
 * 检测系统设置是否打开了消息推送
 */
+ (BOOL)isAllowPushNoti;

/**
 *  获取用户导出音乐权限的详细状态
 *
 *  @return 权限状态
 */
+ (MPMediaLibraryAuthorizationStatus)mediaLibraryStatues;
/**
 *  检测系统是否允许导出音乐
 *  注意: 读取权限状态的方法只支持9.3+系统 低于此系统的默认返回YES
 *  @return YES 允许
 */
+ (BOOL)isAllowMediaLibrary;
/**
 *  请求导出音乐的权限
 *  注意: 请求权限状态的方法只支持9.3+系统 低于此系统默认为用户已经授权
 *  @param block 用户允许 或者拒绝后的回掉block
 */
+ (void)requestMediaAccessWithOperationBlock:(void (^)(BOOL granted))block;
@end
