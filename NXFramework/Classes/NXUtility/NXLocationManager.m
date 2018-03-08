//
//  NXLocationManager.m
//  NXlib
//
//  Created by AK on 14/10/20.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXLocationManager.h"

#import "NXConfig.h"

#import <objc/runtime.h>
#import "UIAlertView+NXAddition.h"

static void *NXCLLocationManagerAuthorizationTypeKey = &NXCLLocationManagerAuthorizationTypeKey;

@implementation CLLocationManager (NXLocationManager)

@dynamic authorizationType;

- (CLLocationManagerAuthorizationType)authorizationType
{
    id authorizationTypeObject = objc_getAssociatedObject(self, NXCLLocationManagerAuthorizationTypeKey);
    return [authorizationTypeObject integerValue];
}

- (void)setAuthorizationType:(CLLocationManagerAuthorizationType)authorizationType
{
    id authorizationTypeObject = @(authorizationType);
    objc_setAssociatedObject(self, NXCLLocationManagerAuthorizationTypeKey, authorizationTypeObject,
                             OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface NXLocationManager ()<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, copy) NXLocationManagerDidUpdateHandler didUpdateHandler;

@property(nonatomic, copy) NXLocationManagerDidFailHandler didFailHandler;

@property(nonatomic, copy) NXLocationManagerConfigHandler configHandler;

@end

@implementation NXLocationManager

NXSINGLETON(NXLocationManager);

- (instancetype)init
{
    if (self = [super init])
    {
        _stopWhenDidUpdate = YES;
        _stopWhenDidFail = YES;
        _alertWhenDidFail = YES;
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_stopWhenDidUpdate)
    {
        [manager stopUpdatingLocation];
    }

    if (_didUpdateHandler)
    {
        _didUpdateHandler(locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_stopWhenDidFail)
    {
        [manager stopUpdatingLocation];
    }

    if (_didFailHandler)
    {
        _didFailHandler(error);
    }

    if (_alertWhenDidFail)
    {
        NSString *message = NSLocalizedStringFromTable(@"NXFW_LS_Locate Fail", @"NXFWLocalizable", nil);

        [UIAlertView nx_showWithMessage:message];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    //tagert 最低版本>iOS8.0
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        [manager startUpdatingLocation];
    }
#else
    double sv = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sv >= 8.0f)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
        {
            [manager startUpdatingLocation];
        }
#pragma clang diagnostic pop
        else
        {
            if (status == kCLAuthorizationStatusAuthorized)
            {
                [manager startUpdatingLocation];
            }
        }
    }
    else
    {
        if (status == kCLAuthorizationStatusAuthorized)
        {
            [manager startUpdatingLocation];
        }
    }
#endif
}

#pragma mark - Public Method

- (void)startLocateWithConfig:(NXLocationManagerConfigHandler)configHandler
                    didUpdate:(NXLocationManagerDidUpdateHandler)didUpdateHandler
                      didFail:(NXLocationManagerDidFailHandler)didFailHandler
{
    self.configHandler = configHandler;
    self.didUpdateHandler = didUpdateHandler;
    self.didFailHandler = didFailHandler;

    [self __startLocating];
}

#pragma mark - Private Method

- (void)__startLocating
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([_locationManager respondsToSelector:@selector(setAuthorizationType:)])
        {
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
            _locationManager.authorizationType = CLLocationManagerAuthorizationTypeWhenInUse;
#else
            double sv = [[UIDevice currentDevice].systemVersion doubleValue];
            if (sv >= 8.0f)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
                _locationManager.authorizationType = CLLocationManagerAuthorizationTypeWhenInUse;
#pragma clang diagnostic pop
            }
#endif
        }
#endif
    }
    
    if (_configHandler)
    {
        _configHandler(_locationManager);
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined)
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)] ||
            [_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >=80000
            //tagert兼容的最低版本 > ios8
            if (_locationManager.authorizationType == CLLocationManagerAuthorizationTypeAlways)
            {
                [_locationManager requestAlwaysAuthorization];
            }
            else
            {
                [_locationManager requestWhenInUseAuthorization];
            }
#else
            double sv = [[UIDevice currentDevice].systemVersion doubleValue];
            if (sv >= 8.0)
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
                if (_locationManager.authorizationType == CLLocationManagerAuthorizationTypeAlways)
                {
                    [_locationManager requestAlwaysAuthorization];
                }
                else
                {
                    [_locationManager requestWhenInUseAuthorization];
                }
#pragma clang diagnostic pop
            }
            
#endif
        }
        else
        {
            [_locationManager startUpdatingLocation];
        }
#else
        [_locationManager startUpdatingLocation];
#endif
    }
    else if (authorizationStatus == kCLAuthorizationStatusRestricted ||
             authorizationStatus == kCLAuthorizationStatusDenied)
    {
        NSString *message = NSLocalizedStringFromTable(@"NXFW_LS_Location Services Disenable", @"NXFWLocalizable", nil);
        
        [UIAlertView nx_showWithMessage:message];
    }
    else
    {
        [_locationManager startUpdatingLocation];
    }
}

@end
