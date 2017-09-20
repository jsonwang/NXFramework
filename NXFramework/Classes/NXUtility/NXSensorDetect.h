//
//  NXSensorDetect.h
//  Philm
//
//  Created by 陈方方 on 2017/4/7.
//  Copyright © 2017年 yoyo. All rights reserved.
// 检测传感器是否可用

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM(NSUInteger, NXCameraDeviceDetectType) {
    NXCameraDeviceDetectTypeBoth,  //前后都可用
    NXCameraDeviceDetectTypeFront,  //只有前置可用
    NXCameraDeviceDetectTypeBack,   //只有后置可用
    NXCameraDeviceDetectTypeNone ,  //前后都不可用
};

@interface NXSensorDetect : NSObject

/**
 
 @return 检测是否存在摄像头
 */
+ (BOOL)nx_isCameraAvailable;

/**
 
 @return  检测前置摄像头是否可用
 */
+ (BOOL)nx_isFrontCameraAvailabel;

/**

 @return 后置摄像头是否可用
 */
+ (BOOL)nx_isBackCameraAvailabel;
/**
 检查当前设备摄像头的可用状态
 
 @return 可用状态
 */
+ (NXCameraDeviceDetectType )nx_checkCameraDevice;


/**
 
 @return 摄像头是否支持录像
 */
+ (BOOL)nx_isCameraSupportShootingVideos;
/**
 
 @return 摄像头是否支持拍照
 */
+ (BOOL)nx_isCameraSupportTakingPhotos;

/**
 
 @return 相册中是否有视频
 */
+ (BOOL)nx_canUserPickVideosFromPhotoLibrary;
/**
 
 @return 相册中是否有照片
 */
+ (BOOL)nx_canUserPickPhotosFromPhotoLibrary;
/**
 相册是否可用
 
 @param souceType 相册类型
 @return 指定类型的相册是否可用
 */
+ (BOOL)nx_isPhotoLibraryAvailableWithSouceType:(UIImagePickerControllerSourceType)souceType;

/**

 @return 查麦克风是否可用
 */
+(BOOL)nx_audioAvailbel;
/**
 @return 闪光灯是否可用
 */
+ (BOOL)nx_isCameraFlashAvailable;
/**
 @return 检测陀螺仪是否可用
 */
+ (BOOL)nx_isGyroscopeAvailable;
/**
 @return 检测指南针或磁力计
 */
+ (BOOL)nx_isHandingAvailable;
/**
 @return 检测视网膜屏
 */
+ (BOOL)nx_isRetinaDisplay;
/**
 @return 检测拨打电话功能
 */
+ (BOOL)nx_canMakeCalls;

@end
