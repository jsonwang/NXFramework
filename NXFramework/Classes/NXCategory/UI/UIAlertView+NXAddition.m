//
//  UIAlertView+NXAddition.m
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "UIAlertView+NXAddition.h"

@implementation UIAlertView (NXAddition)

+ (void)nx_showWithMessage:(NSString *)message
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"NXFW_LS_OK", @"NXFWLocalizable", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
    [alert show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)nx_showWithTitle:(NSString *)title message:(NSString *)message
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"NXFW_LS_OK", @"NXFWLocalizable", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
    [alert show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)nx_showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    NSString *cancelTitle = NSLocalizedStringFromTable(@"NXFW_LS_OK", @"NXFWLocalizable", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
    [alert show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)nx_showWithTitle:(NSString *)title
                 message:(NSString *)message
                delegate:(id)delegate
       cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    [alert show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

+ (void)nx_showWithTitle:(NSString *)title
                 message:(NSString *)message
                delegate:(id)delegate
       cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle
                     tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
    [alert setTag:tag];
    [alert show];
#if !__has_feature(objc_arc)
    [alert release];
#endif
}

@end
