//
//  NXFramework.h
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

//当前版本0.1

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
#import "UIButton+NXTimer.h"
// 能更新...../.
// -------------------------- views -------------------------- //
#import "NXButton.h"
#import "NXCreateUITool.h"
#import "NXLineLabel.h"
#import "NXAlertView.h"
#import "NXSegmentView.h"

// -------------------------- network -------------------------- //
#import "NXNetWorkManagerHeader.h"

// -------------------------- debug -------------------------- //
#import "NXLog.h"
#import "NXLogManager.h"
#import "NXMonitorView.h"

#endif
