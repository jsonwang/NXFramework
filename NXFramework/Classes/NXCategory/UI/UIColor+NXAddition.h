//
//  UIColor+NXAddition.h
//  NXlib
//
//  Created by AK on 3/5/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NXAddition)


/**
 * 初始化
 *
 */
+ (UIColor *)nx_colorWithWholeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)nx_colorWithWholeRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)nx_colorWithHex:(NSInteger)hexColor alpha:(CGFloat)alpha;

+ (UIColor *)nx_colorWithHex:(NSInteger)hexColor;


/**
 * 获取当前颜色的RGB值
 * @return 颜色值数组
 */
- (NSArray *)nx_RGBComponents;

@end
