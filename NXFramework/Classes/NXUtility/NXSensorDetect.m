//
//  NXSensorDetect.m
//  Philm
//
//  Created by 陈方方 on 2017/4/7.
//  Copyright © 2017年 yoyo. All rights reserved.
// 检测传感器是否可用

#import "NXSensorDetect.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreMotion/CoreMotion.h>

#import <AVFoundation/AVFoundation.h>

@implementation NXSensorDetect

#pragma mark - cameraDevice

/**
 @return 检测是否存在摄像头
 */
+ (BOOL)nx_isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


/**
 
 @return 检测前置摄像头是否可用
 */
+ (BOOL)nx_isFrontCameraAvailabel
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


/**
 
 @return  后置摄像头是否可用
 */
+ (BOOL)nx_isBackCameraAvailabel
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

/**
 检查当前设备摄像头的可用状态
 
 @return 可用状态
 */
+ (NXCameraDeviceDetectType )nx_checkCameraDevice
{
    NXCameraDeviceDetectType type = NXCameraDeviceDetectTypeBoth;
    if (![NXSensorDetect nx_isCameraAvailable])
    {//没有相机
        return NXCameraDeviceDetectTypeNone;
    }
    
    BOOL frontAvailabel = [NXSensorDetect nx_isFrontCameraAvailabel];
    BOOL backAvailabel = [NXSensorDetect nx_isBackCameraAvailabel];
    
    if (!frontAvailabel && !backAvailabel)
    {//前后都不可用
        return NXCameraDeviceDetectTypeNone;
    }
    if (frontAvailabel && !backAvailabel)
    {//只有前置可用
        return NXCameraDeviceDetectTypeFront;
    }
    if (!frontAvailabel && backAvailabel)
    {//只有后置可用
        return NXCameraDeviceDetectTypeBack;
    }
    if (frontAvailabel && backAvailabel)
    {//前后都可用
        return NXCameraDeviceDetectTypeBoth;
    }
    
    return type;
}
#pragma  cameraSupportsMedia


/**
 判断是否支持某种多媒体类型：拍照，视频
 
 @param paramMediaType  多媒体类型
 @param paramSourceType 渠道类型
 @return 是否支持
 */
+ (BOOL)nx_isCameraSupportsMedia:(NSString *)paramMediaType
                      sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0)
    {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString *mediaType = (NSString *)obj;
         if ([mediaType isEqualToString:paramMediaType])
         {
             result = YES;
             *stop = YES;
         }
     }];
    return result;
}


/**
 
 @return 摄像头是否支持录像
 */
+ (BOOL)nx_isCameraSupportShootingVideos
{
    return [NXSensorDetect nx_isCameraSupportsMedia:(NSString *)kUTTypeMovie
                                         sourceType:UIImagePickerControllerSourceTypeCamera];
}

/**
 
 @return 摄像头是否支持拍照
 */
+ (BOOL)nx_isCameraSupportTakingPhotos
{
    return [NXSensorDetect nx_isCameraSupportsMedia:(NSString *)kUTTypeImage
                                         sourceType:UIImagePickerControllerSourceTypeCamera];
}


/**
 
 @return 相册中是否有视频
 */
+ (BOOL)nx_canUserPickVideosFromPhotoLibrary
{
    return [NXSensorDetect nx_isCameraSupportsMedia:(NSString *)kUTTypeMovie
                                         sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

/**
 
 @return 相册中是否有照片
 */
+ (BOOL)nx_canUserPickPhotosFromPhotoLibrary
{
    return [NXSensorDetect nx_isCameraSupportsMedia:(NSString *)kUTTypeImage
                                         sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

/**
 相册是否可用
 
 @param souceType 相册类型
 @return 指定类型的相册是否可用
 */
+ (BOOL)nx_isPhotoLibraryAvailableWithSouceType:(UIImagePickerControllerSourceType)souceType
{
    return [UIImagePickerController isSourceTypeAvailable:souceType];
}

//检查麦克风是否可用
+(BOOL)nx_audioAvailbel
{
    return  [AVAudioSession sharedInstance].inputAvailable;//bool值。获取是否支持
}

/**
 @return 闪光灯是否可用
 */
+ (BOOL)nx_isCameraFlashAvailable
{//只有后置的
    
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - other

/**
 @return 检测陀螺仪是否可用
 */
+ (BOOL)nx_isGyroscopeAvailable
{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    return motionManager.gyroAvailable;
}


/**
 @return 检测指南针或磁力计
 */
+ (BOOL)nx_isHandingAvailable
{
    return [CLLocationManager headingAvailable];
}

/**
 @return 检测视网膜屏
 */
+ (BOOL)nx_isRetinaDisplay
{
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)])
    {
        return screen.scale >= 2.0;
    }
    return NO;
}


/**
 @return 检测拨打电话功能
 */
+ (BOOL)nx_canMakeCalls
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}


@end
