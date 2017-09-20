//
//  UIControl+acceptEventInterval.h
//  NXlib
//
//  Created by AK on 15/9/15.
//  Copyright (c) 2015年 AK. All rights reserved.
//

// 本类的作用
// 防止多次连续点击事件，加一个两次点击的时间间隔,专治各种测试人员-_-!
// 使用 addTarget:action:forControlEvents 给对象添加事件的都可以加时间间隔 如
// UIButton、UISwitch、UITextField

/*
 *	UIButton * testBtn;
 *  testBtn.uxy_acceptEventInterval = 2.5;
 */
#import <UIKit/UIKit.h>

@interface UIControl (NXCategory)

/**
 *  设置重复点击加间隔。
 */
@property(nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;

/**
 *  忽略本次点击。
 */
@property(nonatomic) BOOL ignoreEvent;

@end
