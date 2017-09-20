//
//  UIViewController+swizzling.m
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "UIViewController+swizzling.h"
#import <objc/runtime.h>

//#import "NXAnalyticsManage.h"
#import "NSObject+NXCategory.h"

@implementation UIViewController (swizzling)

#pragma mark - Util methods

+ (void)load
{
    [self nx_swizzleClassMethod:@selector(viewWillAppear:) withClassMethod:@selector(swizzviewWillAppear:)];

    [self nx_swizzleClassMethod:@selector(viewWillDisappear:) withClassMethod:@selector(swizzviewWillDisappear:)];
}

- (void)swizzviewWillAppear:(BOOL)animated
{
    NSTimeInterval enterInterval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@ enter on %f ", [NSString stringWithUTF8String:object_getClassName(self)], enterInterval);

    //    // 调用管理类发给服务器
    //    [NXAnalyticsManage beginLogPageView:[NSString
    //    stringWithUTF8String:object_getClassName(self)]];

    [self swizzviewWillAppear:animated];
}

- (void)swizzviewWillDisappear:(BOOL)animated
{
    NSTimeInterval exitInterval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@ exit on %f", [NSString stringWithUTF8String:object_getClassName(self)], exitInterval);
    // 调用管理类发给服务器
    //    [NXAnalyticsManage beginLogPageView:[NSString
    //    stringWithUTF8String:object_getClassName(self)]];
    [self swizzviewWillDisappear:animated];
}

@end
