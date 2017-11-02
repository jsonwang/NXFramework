//
//  NXDevicePermission.m
//  AKImovie
//
//  Created by AK on 16/3/16.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "NXDevicePermission.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/Photos.h>
#endif

#import "NXConfig.h"

@import AddressBook;
@import Accounts;
@import AdSupport;
@import AssetsLibrary;
@import AVFoundation;
@import CoreMotion;

@import CoreBluetooth;
@import CoreLocation;

@implementation NXDevicePermission

+ (void)autoJumpSetting
{
    if (NX_iOS8_OR_LATER)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - 相机
+ (BOOL)isAllowCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    return authStatus == AVAuthorizationStatusAuthorized;
}

#pragma mark - 相册
+ (BOOL)isAllowPhotoAlbum
{
    Class cla = NSClassFromString(@"PHPhotoLibrary");
    if(cla)
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        return status == PHAuthorizationStatusAuthorized;
        
    }
    else
    {
     
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        return authStatus == ALAuthorizationStatusAuthorized ? YES : NO;
        
    }
}

+ (BOOL)requestPhotosAccess
{
    __block BOOL resu = YES;
    Class cla = NSClassFromString(@"PHPhotoLibrary");
    if (cla)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            resu = (status == ALAuthorizationStatusAuthorized);
        }];
        
    }
    else
    {
     
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                        /*
                                         Do something with the requested assets
                                         */
                                        
                                        resu = YES;
                                    }
                                  failureBlock:^(NSError *error) {
                                      /*
                                       Handle failure
                                       */
                                      resu = NO;
                                  }];
        
    }
    return resu;
}
+ (void)requestPhotosAccessWithOperationBlock:(void (^)(BOOL granted))block
{
    Class cla = NSClassFromString(@"PHPhotoLibrary");
    if (cla)
    {
        __block BOOL hasAuthorAcces = NO;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (!hasAuthorAcces) {
                hasAuthorAcces = YES;
                if (block) {
                    block((status == ALAuthorizationStatusAuthorized));
                }
            }
            
        }];
        
    } else {
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        __block BOOL hasAuthorAcces = NO;
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                        /*
                                         Do something with the requested assets
                                         */
                                        if (!hasAuthorAcces)
                                        {
                                            hasAuthorAcces = YES;
                                            
                                            if (block)
                                            {
                                                block(YES);
                                            }
                                        }
                                        
                                    }
                                  failureBlock:^(NSError *error) {
                                      /*
                                       Handle failure
                                       */
                                      if(!hasAuthorAcces){
                                          
                                          hasAuthorAcces = YES;
                                          if (block)
                                          {
                                              block(NO);
                                          }
                                      }
                                      
                                  }];
    }
    
}
#pragma mark - 麦克风
+ (BOOL)isAllowDeviceMicophone
{
    __block BOOL isAllow = YES;

    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    if (sysVersion >= 8.0)
    {
        AVAudioSessionRecordPermission sessionRecordPermission = [[AVAudioSession sharedInstance] recordPermission];

        isAllow = sessionRecordPermission == AVAudioSessionRecordPermissionGranted;
    }
    else
    {
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
        {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

                if (granted)
                {
                    isAllow = YES;
                }
                else
                {
                    isAllow = NO;
                }
            }];
        }
    }

    return isAllow;
}
+ (void)requestMicrophoneAccessWithOperationBlock:(void (^)(BOOL granted))block
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session requestRecordPermission:^(BOOL granted) {
        if (granted)
        {
            NSError *error;
            /*
             Setting the category will also request access from the user
             */
            [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
            /*
             Do something with the audio session
             */
        }
        else
        {
            /*
             Handle failure
             */
        }
        if (block)
        {
            block(granted);
        }
    }];
}
+ (void)requestMicrophoneAccess
{
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session requestRecordPermission:^(BOOL granted) {
        if (granted)
        {
            NSError *error;
            /*
             Setting the category will also request access from the user
             */
            [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];

            /*
             Do something with the audio session
             */
        }
        else
        {
            /*
             Handle failure
             */
        }

    }];
}

+ (BOOL)isSilenced { return NO; }
#pragma mark - 地理位置
+ (BOOL)isAllowLocaiton { return [CLLocationManager locationServicesEnabled]; }
+ (CLAuthorizationStatus)appIsAllowLocation { return [CLLocationManager authorizationStatus]; }
#pragma mark - 通信录
+ (BOOL)isAllowAddressBook
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();

    return status == ALAuthorizationStatusAuthorized ? YES : NO;
}

#pragma mark - 蓝牙
+ (BOOL)isAllowBluetooth
{
    CBCentralManager *cbManager = [[CBCentralManager alloc] initWithDelegate:nil queue:nil];

    return [cbManager state] == CBCentralManagerStatePoweredOn ? YES : NO;
}

#pragma makr - 第三方账号
+ (BOOL)isAllowSocialAccountAuthorizationStatus:(NSString *)accountTypeIndentifier
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];

    ACAccountType *socialAccount = [accountStore accountTypeWithAccountTypeIdentifier:accountTypeIndentifier];

    return [socialAccount accessGranted] ? YES : NO;
}

+ (void)requestSocialAccountAuthor:(NSString *)accountTypeIndentifier complent:(void(^)(BOOL granted, NSError *error)) block
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];

    ACAccountType *sinaWeiboAccount = [accountStore accountTypeWithAccountTypeIdentifier:accountTypeIndentifier];

    [accountStore requestAccessToAccountsWithType:sinaWeiboAccount
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           
                                           if (block)
                                           {
                                               block(granted,error);
                                           }
                                       }];
}

#pragma mark - 日历
+ (BOOL)isAlloEventStoreAccessForType:(EKEntityType)type
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];

    return (status == EKAuthorizationStatusAuthorized) ? YES : NO;
}

+ (void)requestEventStoreAccessWithType:(EKEntityType)type
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];

    [eventStore requestAccessToEntityType:type
                               completion:^(BOOL granted, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{

                                                      /*
                                                       Do something with the access to eventstore...
                                                       */
                                                  });
                               }];
}

#pragma makr - Advertising
+ (BOOL)advertisingIdentifierStatus
{
    return ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) ? YES : NO;
}

+ (BOOL)isAllowPushNoti
{
    BOOL isAllow = NO;
    if (NX_iOS8_OR_LATER)
    {
        isAllow = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
        //7.0
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type != UIRemoteNotificationTypeNone)
        {
            isAllow = YES;
        }
#endif
    }


    return isAllow;
}

+ (void)requestCameraAccessWithOperationBlock:(void (^)(BOOL granted))block
{
    CGFloat OS_Version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (OS_Version >= 7.0)
    {
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized)
        {
            // authorized
            //            [self presentViewController:self.imagePickerController
            //            animated:YES completion:nil];
            if (block)
            {
                block(YES);
            }
        }
        else if (status == AVAuthorizationStatusDenied)
        {
            // denied
            if (block)
            {
                block(NO);
            }

            return;
        }
        else if (status == AVAuthorizationStatusRestricted)
        {
            // restricted
            if (block)
            {
                block(NO);
            }
        }
        else if (status == AVAuthorizationStatusNotDetermined)
        {
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                
                                         if (block)
                                         {
                                             block(granted);
                                         }

                                     }];
        }
    }
}
+ (void)requestCameraAccess
{
    CGFloat OS_Version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (OS_Version >= 7.0)
    {
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized)
        {
            // authorized
            //            [self presentViewController:self.imagePickerController
            //            animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusDenied)
        {
            // denied
            return;
        }
        else if (status == AVAuthorizationStatusRestricted)
        {
            // restricted
        }
        else if (status == AVAuthorizationStatusNotDetermined)
        {
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted)
                                         {
                                             //                    [self
                                             //                    presentViewController:self.imagePickerController
                                             //                    animated:YES
                                             //                    completion:nil];
                                         }
                                         else
                                         {
                                             return;
                                         }
                                     }];
        }
    }
}

+ (MPMediaLibraryAuthorizationStatus)mediaLibraryStatues
{
    double sysVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sysVersion >= 9.3)
    {
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        return status;
    }

    return MPMediaLibraryAuthorizationStatusAuthorized;
}
+ (BOOL)isAllowMediaLibrary { return [self mediaLibraryStatues] == MPMediaLibraryAuthorizationStatusAuthorized; }
+ (void)requestMediaAccessWithOperationBlock:(void (^)(BOOL granted))block
{
    double sysVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sysVersion >= 9.3)
    {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {

            BOOL granted = status == MPMediaLibraryAuthorizationStatusAuthorized;
            if (block)
            {
                block(granted);
            }
        }];
    }
    else
    {
        if (block)
        {
            block(YES);
        }
    }
}
@end
