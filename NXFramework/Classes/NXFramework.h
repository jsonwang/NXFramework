//
//  NXFramework.h
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

//当前版本0.1

 /*
 使用说明 XXXX 非常重要
 要导入
 1,libsqlite3.0.tbd FMDB使用
 2,libz.tbd  NSData+NXCategory gzip 使用
 
 方法1:
 Targets --> build Settings --> Other Linker Flags  添加 -lz  -lsqlite3
 方法2:
 Targets --> build phases --> link binary with libraries  加库  libsqlite3.0.tbd  libz.tbd
 3,要导入SDWebImage ,NXLaunchVC.m 使用
  
 */

///////////////////////////// pod file set
/*
 
 # Uncomment the next line to define a global platform for your project
 source 'https://github.com/CocoaPods/Specs.git'
 platform :ios, '8.0'
 
 target 'NXNetworkManager' do
 # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
 # use_frameworks!
 # Pods for NXNetworkManager
 
 pod 'AFNetworking' , '~> 3.1.0'  #必要 === 网络库 同看 https://github.com/shaioz/AFNetworking-AutoRetry
 
 pod 'Aspects' , '~> 1.4.1' #非必要 === 面向切面编程 https://wereadteam.github.io/2016/06/30/Aspects/
 
 pod 'FMDB', '~> 2.7.2' #必要 === 数据库
 
 pod 'MJRefresh', '~> 3.1.12'  #非必要 === 下载刷新组件
 
 pod 'MLeaksFinder', '~> 1.0.0' #非必要 === 精准 iOS 内存泄露检测工具 https://wereadteam.github.io/2016/02/22/MLeaksFinder/
 
 pod 'SDAutoLayout', '~> 2.2.0' #非必要
 
 pod 'SDWebImage', '~> 4.1.0'  #必要
 
 pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
 
 end   #非必要

 
 */



#ifndef NXlib_NXFramework_h
#define NXlib_NXFramework_h

//#ifndef __IPHONE_10_0
//#warning "This project uses features only available in iPhone SDK 10.0 and
// later."
//#endif

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>

#endif

// -------------------------- Common -------------------------- //

#import "NXConfig.h"
#import "NXMath.h"

// -------------------------- NXFoundation -------------------------- //


// -------------------------- Adapted -------------------------- //
#import "NXAdaptedDevice.h"
#import "NXAdaptedSystem.h"

// -------------------------- Utility -------------------------- //
#import "NXPlayer.h"
#import "NXReachability.h"
#import "NXSystemInfo.h"
#import "NXArchivedManager.h"
#import "NXDevicePermission.h"
#import "NXFileManager.h"
#import "NXMuteSwitch.h"
#import "NXSendMail.h"
#import "NXSpotlight.h"
#import "NXVolumeObserver.h"
#import "NXVideoMerge.h"
#import "NXSensorDetect.h"

// -------------------------- autoLayout -------------------------- //
#import "UIView+SDAutoLayout.h"

// -------------------------- Category -------------------------- //
#import "NSArray+NXCategory.h"
#import "NSData+NXCategory.h"
#import "NSDate+NXCategory.h"
#import "NSDictionary+NXCategory.h"
#import "NSObject+NXCategory.h"
#import "NSString+NXCategory.h"
#import "NSURL+NXCategory.h"
#import "NSUserDefaults+NXCategory.h"
//
//
#import "UIAlertView+NXAddition.h"
#import "UIView+NXCategory.h"
#import "UIViewController+swizzling.h"
#import "NXUIDevice-Hardware.h"
#import "UIAlertView+NXAddition.h"
#import "UIControl+NXCategory.h"
#import "UIImage+NXCategory.h"
#import "UIViewController+NXAddiction.h"

// -------------------------- views -------------------------- //
#import "NXButton.h"
#import "NXCreateUITool.h"
#import "NXLineLabel.h"
#import "NXAlertView.h"
#import "NXSegmentView.h"

// -------------------------- network -------------------------- //
#import "NXNetworkManager/NXNetWorkManagerHeader.h"

// -------------------------- debug -------------------------- //
#import "NXLog.h"
#import "NXLogManager.h"
#import "NXMonitorView.h"

#endif
