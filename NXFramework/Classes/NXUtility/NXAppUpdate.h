//
//  NXAppUpdate.h
//  NXLib
//
//  Created by AK on 14-2-19.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/**
 检查苹果商店有无最新版本APP
 
 NXAppUpdate * app = [NXAppUpdate sharedInstance ];
 app.appID =@"1146696085";
 [app checkVersion];
 */

#include "NXObject.h"

extern NSString *const NXVersionManagerLanguageEnglish;
extern NSString *const NXVersionManagerLanguageChineseSimplified;
extern NSString *const NXVersionManagerLanguageChineseTraditional;

typedef NS_ENUM(NSUInteger, NXVersionAlertType) {
    NXVersionAlertTypeDefault,
    NXVersionAlertTypeSkip,
    NXVersionAlertTypeForce,
};

@protocol NXAppUpdateDelegate<NSObject>

@optional
- (void)versionManagerDidPresentAlert;
- (void)versionManagerDidLaunchAppStore;
- (void)versionManagerDidSkipVersion;
- (void)versionManagerDidCancel;

@end

@interface NXAppUpdate : NXObject
{
}

@property(nonatomic, weak) id<NXAppUpdateDelegate> delegate;

@property(nonatomic, retain) NSString *appID;

@property(nonatomic, retain) NSString *appName;

@property(nonatomic, retain) NSString *countryCode;

@property(nonatomic, assign) NXVersionAlertType alertType;


+ (NXAppUpdate *)sharedInstance;

/**
 检查当前版本是否需要更新
 */
- (void)checkVersion;

/**
 距离上次检查更新超过1天 再次检查版本是否需要更新
 */
- (void)checkVersionDaily;


/**
 距离上次检查更新超过7天 再次检查版本是否需要更新
 */
- (void)checkVersionWeekly;

@end
