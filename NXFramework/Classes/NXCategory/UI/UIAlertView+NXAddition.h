//
//  UIAlertView+NXAddition.h
//  NXlib
//
//  Created by AK on 15/3/1.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NXAddition)

/**
 * 显示只有一个按钮 没有标题只有内容的alert
 * @param message alert内容
 *
 */
+ (void)nx_showWithMessage:(NSString *)message;

/**
 * 显示只有一个按钮 有标题和内容的alert
 *
 * @param title alert标题
 * @param message alert内容
 *
 */
+ (void)nx_showWithTitle:(NSString *)title message:(NSString *)message;

+ (void)nx_showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

/**
 * 显示有两个按钮 有标题和内容的alert
 *
 * @param title alert标题
 * @param message alert内容
 * @param delegate 代理参数
 * @param cancelButtonTitle 取消按钮标题
 * @param otherButtonTitle 其他按钮标题
 *
 */
+ (void)nx_showWithTitle:(NSString *)title
                 message:(NSString *)message
                delegate:(id)delegate
       cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle;

+ (void)nx_showWithTitle:(NSString *)title
                 message:(NSString *)message
                delegate:(id)delegate
       cancelButtonTitle:(NSString *)cancelButtonTitle
        otherButtonTitle:(NSString *)otherButtonTitle
                     tag:(NSInteger)tag;

@end
