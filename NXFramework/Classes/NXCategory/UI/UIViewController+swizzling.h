//
//  UIViewController+swizzling.h
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

/**
 * 说明:写本数的目地 是处理 APP 中统计功能, 使用swizz
 * 代码注入把统计和业务逻辑分开.本类是界面路径的统计和UIControl+NXCategory.h
 * 配合使用.UIControl+NXCategory 是btn onclick event 事件统计.
 * 一,界面统计相关要求1，进入界面.(进到朋友圈界面发统计）2,从指定A界面进入到 到B
 * 界面（eg,从首界面
 * 进入到个人中心，从好友列表进入到个人中心）3,在朋友圈界面的停留时长。
 *
 * 二,btn统计相关要求 １,点击事件(注册btn)　２,点击加参数(dic 点击btn
 * 时的网络状态)　３,统计事件时长(从点注册按键开始到注册成功)
 *
 */

#import <UIKit/UIKit.h>

@interface UIViewController (swizzling)

@end
