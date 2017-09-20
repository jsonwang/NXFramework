//
//  UIColor+NXDebug.m
//  NXlib
//
//  Created by AK on 14-5-20.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "UIColor+NXDebug.h"

@implementation UIColor (NXDebug)

+ (UIColor *)randomColor
{
    CGFloat red = (arc4random() % 256) / 256.0;
    CGFloat green = (arc4random() % 256) / 256.0;
    CGFloat blue = (arc4random() % 256) / 256.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
