//
//  NXAppReview.m
//  NXlib
//
//  Created by AK on 14-5-22.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXAppReview.h"

#import <StoreKit/StoreKit.h>

//评论地址
#define TEMPLATEREVIEWURLIOS7 @"itms-apps://itunes.apple.com/app/idAPP_ID"

//苹果商店地址
//https://itunes.apple.com/cn/app/idxxxxx?mt=8

@interface NXAppReview ()<SKStoreProductViewControllerDelegate>
{
}

@end

@implementation NXAppReview

@synthesize delegate;

NXSINGLETON(NXAppReview);

- (id)init
{
    if (self = [super init])
    {
    }

    return self;
}

- (void)rateAppWitchAppID:(NSString *)APPID
{
    // iOS 6 或更高
    if (NSStringFromClass([SKStoreProductViewController class]) != nil)
    {
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSNumber *appId = [NSNumber numberWithInteger:APPID.integerValue];

        [storeViewController loadProductWithParameters:@{
            SKStoreProductParameterITunesItemIdentifier : appId
        }
                                       completionBlock:nil];

        storeViewController.delegate = self;

        [[self getRootViewController] presentViewController:storeViewController
                                                   animated:YES
                                                 completion:^{

                                                     // XXXX TODO what?
                                                 }];

        if ([delegate respondsToSelector:@selector(appReviewWillPresentModalView:animated:)])
        {
            [delegate appReviewWillPresentModalView:self animated:YES];
        }
    }
    else
    {
#if TARGET_IPHONE_SIMULATOR

        NSLog(@"苹果说了不让在 模拟器中打开 app store!!!");

#else

        [[UIApplication sharedApplication]
            openURL:[NSURL URLWithString:[TEMPLATEREVIEWURLIOS7 stringByReplacingOccurrencesOfString:@"APP_ID"
                                                                                          withString:APPID]]];

#endif
    }
}

- (id)getRootViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (window in windows)
        {
            if (window.windowLevel == UIWindowLevelNormal)
            {
                break;
            }
        }
    }

    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return [self topMostViewController:(UIViewController *)responder];
        }
    }

    return nil;
}

- (UIViewController *)topMostViewController:(UIViewController *)controller
{
    BOOL isPresenting = NO;

    do
    {
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;

        if (presented != nil)
        {
            controller = presented;
        }

    } while (isPresenting);

    return controller;
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    UIViewController *presentingController = [UIApplication sharedApplication].keyWindow.rootViewController;

    presentingController = [self topMostViewController:presentingController];

    [presentingController
        dismissViewControllerAnimated:YES
                           completion:^{

                               if ([delegate respondsToSelector:@selector(appReviewDidDismissModalView:animated:)])
                               {
                                   [delegate appReviewDidDismissModalView:self animated:YES];
                               }

                           }];
}

@end
