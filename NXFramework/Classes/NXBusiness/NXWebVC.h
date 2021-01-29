//
//  NXWebVC.h
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWebVC : UIViewController


@property(nonatomic, copy) NSString *urlTitle;

@property(nonatomic, copy) NSString *urlStr;

@property(nonatomic, assign) BOOL isPresent;

@property(copy) void (^hideWebView)(void);


//=============自定义导航条==============
//返回按钮图片
@property(nonatomic, copy) UIImage *backImage;

//返回按钮选中图片
@property(nonatomic, copy) UIImage *backSelectImage;
//返回按钮name
@property(nonatomic, copy) NSString *backTitle;

@property(nonatomic, copy) UIColor *naviColor;


/**
  设置标题 font 默认为 [UIFont boldSystemFontOfSize:20]
 */
@property(nonatomic,copy) UIFont *titleFont;
//标题字颜色
@property(nonatomic, copy) UIColor *titleColor;

//背景颜色
@property(nonatomic, copy) UIColor *backgroudColor;

// 超时时间 默认15s
@property(nonatomic,assign)NSTimeInterval timeoutInterval;
@end
