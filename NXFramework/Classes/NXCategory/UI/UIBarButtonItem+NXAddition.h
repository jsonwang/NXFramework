//
//  UIBarButtonItem+NXAddition.h
//  NXlib
//
//  Created by AK on 9/23/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NXAddition)

/**
 * 初始化
 *
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem;
- (instancetype)initWithFixedSpaceWidth:(CGFloat)spaceWidth;

/**
 * 初始化一个 自动调节按钮间的间距 的 UIBarButtonItem
 *
 */
+ (instancetype)nx_flexibleSpaceSystemItem;

@end
