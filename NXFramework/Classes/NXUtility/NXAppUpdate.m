//
//  NXAppUpdate.m
//  NXLib
//
//  Created by AK on 14-2-19.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXAppUpdate.h"
#import "NXSystemInfo.h"
#import "NXConfig.h"
#import "NSUserDefaults+NXCategory.h"
#import "NSString+NXCategory.h"
#import "NSData+NXCategory.h"
#import "NSDictionary+NXCategory.h"
#import "NSDate+NXCategory.h"

NSString *const NXVersionManagerLanguageEnglish = @"en";
NSString *const NXVersionManagerLanguageChineseSimplified = @"zh-Hans";
NSString *const NXVersionManagerLanguageChineseTraditional = @"zh-Hant";

/**
 *  最后版本检查日期
 */
static NSString *const NXVersionManagerCheckDateKey = @"Version Last Check Date";
/**
 *  用户是否跳过版本
 */
static NSString *const NXVersionManagerShouldSkipVersionKey = @"User Skip Version Update";
/**
 *  用户跳过版本号
 */
static NSString *const NXVersionManagerDidSkippedVersionKey = @"User Skipped Version Number";

/**
 *  查找版本信息URL
 */
#define NXFW_LOOKUP_VERSION_URL_UNIVERSAL @"http://itunes.apple.com/lookup?id=%@"
/**
 *  查找版本信息URL(指定国家)
 */
#define NXFW_LOOKUP_VERSION_URL_SPECIFIC @"http://itunes.apple.com/lookup?id=%@&country=%@"

@interface NXAppUpdate ()<UIAlertViewDelegate>
{
}

/// 版本信息
@property(strong, nonatomic) NSDictionary *versionInfo;

/// 最后检查日期
@property(strong, nonatomic) NSDate *lastCheckDate;

@end

@implementation NXAppUpdate

NXSINGLETON(NXAppUpdate);

- (id)init
{
    if (self = [super init])
    {
        _alertType = NXVersionAlertTypeDefault;

        _lastCheckDate = [[NSUserDefaults standardUserDefaults] objectForKey:NXVersionManagerCheckDateKey];
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidPresentAlert)])
    {
        [_delegate versionManagerDidPresentAlert];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (_alertType)
    {
        case NXVersionAlertTypeDefault:
        {
            if (1 == buttonIndex)
            {
                [NXSystemInfo launchAppStore:_appID];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)])
                {
                    [_delegate versionManagerDidLaunchAppStore];
                }
            }
            else
            {
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidCancel)])
                {
                    [_delegate versionManagerDidCancel];
                }
            }
            break;
        }
        case NXVersionAlertTypeSkip:
        {
            if (1 == buttonIndex)
            {
                [NXSystemInfo launchAppStore:_appID];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)])
                {
                    [_delegate versionManagerDidLaunchAppStore];
                }
            }
            else if (2 == buttonIndex)
            {
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidCancel)])
                {
                    [_delegate versionManagerDidCancel];
                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] nx_saveBool:YES forKey:NXVersionManagerShouldSkipVersionKey];
                [[NSUserDefaults standardUserDefaults] nx_saveObject:_versionInfo[@"version"]
                                                              forKey:NXVersionManagerDidSkippedVersionKey];
                if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidSkipVersion)])
                {
                    [_delegate versionManagerDidSkipVersion];
                }
            }
            break;
        }
        case NXVersionAlertTypeForce:
        {
            [NXSystemInfo launchAppStore:_appID];
            if (_delegate && [_delegate respondsToSelector:@selector(versionManagerDidLaunchAppStore)])
            {
                [_delegate versionManagerDidLaunchAppStore];
            }
            break;
        }
    }
}

#pragma mark - Public Method
- (void)checkVersion
{
    NSAssert(_appID, @"AppID must not be nil.");

    NSString *lookupURLString = nil;
    if (![NSString nx_isBlankString:_countryCode])
    {
        lookupURLString = [NSString stringWithFormat:NXFW_LOOKUP_VERSION_URL_SPECIFIC, _appID, _countryCode];
    }
    else
    {
        lookupURLString = [NSString stringWithFormat:NXFW_LOOKUP_VERSION_URL_UNIVERSAL, _appID];
    }

    NSURL *lookupURL = [NSURL URLWithString:lookupURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:lookupURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error && [data nx_isNotEmpty])
                               {
                                   
                                   NSMutableDictionary *jsonObject=[NSJSONSerialization
                                                             JSONObjectWithData:data
                                                             options:NSJSONReadingMutableLeaves
                                                             error:nil];
                                   NSLog(@"jsonObject is %@",jsonObject);
 
                                  dispatch_async(dispatch_get_main_queue(),
                                  ^{
                                      self.lastCheckDate = [NSDate date];
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:_lastCheckDate
                                                                                  forKey:NXVersionManagerCheckDateKey];

                                    
                                      NSArray *versions=[jsonObject objectForKey:@"results"];
                                      if(versions.count >0)
                                      {
                                          self.versionInfo = [versions firstObject];
                                          NSString *currentVersion =  [self.versionInfo nx_stringForKey:@"version"];
                                          [self __checkIfUpdateAvailable:currentVersion];
                                      }
                                  });
                               }
                           }];
}

- (void)checkVersionDaily
{
    if (!_lastCheckDate)
    {
        [self checkVersion];
    }

    if ([_lastCheckDate nx_daysSinceDate:[NSDate date]] > 1)
    {
        [self checkVersion];
    }
}

- (void)checkVersionWeekly
{
    if (!_lastCheckDate)
    {
        [self checkVersion];
    }

    if ([_lastCheckDate nx_daysSinceDate:[NSDate date]] > 7)
    {
        [self checkVersion];
    }
}

#pragma mark - Private Method
- (void)__checkIfUpdateAvailable:(NSString *)currentVersion
{
    if ([[NXSystemInfo version] compare:currentVersion options:NSNumericSearch] == NSOrderedAscending)
    {
        [self __showUpdateAlertIfNotSkipped:currentVersion];
    }
}

- (void)__showUpdateAlertIfNotSkipped:(NSString *)currentVersion
{
    BOOL shouldSkipVersion = [[NSUserDefaults standardUserDefaults] boolForKey:NXVersionManagerShouldSkipVersionKey];
    NSString *skippedVersion =
        [[NSUserDefaults standardUserDefaults] stringForKey:NXVersionManagerDidSkippedVersionKey];

    if (!shouldSkipVersion)
    {
        [self __showUpdateAlertWithVersion:currentVersion];
    }
    else if (shouldSkipVersion && ![skippedVersion isEqualToString:currentVersion])
    {
        [self __showUpdateAlertWithVersion:currentVersion];
    }
    else
    {
        NSLog(@"Don't show alert");
        return;
    }
}

- (void)__showUpdateAlertWithVersion:(NSString *)currentVersion
{
    NSString *appName = ![NSString nx_isBlankString:_appName] ? _appName : [NXSystemInfo bundleDisplayName];

    NSString *message = NSLocalizedStringFromTable(@"", @"NXFWLocalizable", nil);
    NSString *title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ 最新版本 %@", @"NXFWLocalizable", nil),
                                                 appName, currentVersion];

    NSString *updateButtonTitle = NSLocalizedStringFromTable(@"现在更新", @"NXFWLocalizable", nil);
    NSString *nextTimeButtonTitle = NSLocalizedStringFromTable(@"下一次在说", @"NXFWLocalizable", nil);
    NSString *skipButtonTitle = NSLocalizedStringFromTable(@"跳过此版本", @"NXFWLocalizable", nil);

    UIAlertView *alertView = nil;
    switch (_alertType)
    {
        case NXVersionAlertTypeDefault:
        {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:nextTimeButtonTitle
                                         otherButtonTitles:updateButtonTitle, nil];
            break;
        }
        case NXVersionAlertTypeSkip:
        {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:skipButtonTitle
                                         otherButtonTitles:updateButtonTitle, nextTimeButtonTitle, nil];
            break;
        }
        case NXVersionAlertTypeForce:
        {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:updateButtonTitle
                                         otherButtonTitles:nil];
            break;
        }
    }
    [alertView show];
}

@end
