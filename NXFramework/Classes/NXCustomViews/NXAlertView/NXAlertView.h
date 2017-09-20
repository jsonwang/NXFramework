//
//  NXAlertView.h
//  NXlib
//
//  Created by AK on 14/12/8.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NXAlertViewClickedHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^NXAlertViewCancelHandler)(UIAlertView *alertView);
typedef void (^NXAlertViewWillPresentHandler)(UIAlertView *alertView);
typedef void (^NXAlertViewDidPresentHandler)(UIAlertView *alertView);
typedef void (^NXAlertViewWillDismissHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^NXAlertViewDidDismissHandler)(UIAlertView *alertView, NSInteger buttonIndex);
typedef BOOL (^NXAlertViewShouldEnableHandler)(UIAlertView *alertView);

@interface NXAlertView : UIAlertView

/**
    初始化NXAlertView
 @param title 标题
 @param message 内容
 @return NXAlertView
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;


/**
 
 初始化NXAlertView
 @param title 标题
 @param message 内容
 @param handler 点击按钮回掉
 @return NXAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               clickedHandler:(NXAlertViewClickedHandler)handler;


/**
 初始化NXAlertView

 @param title 标题
 @param message 内容
 @param otherBtns 显示更多的按钮
 @param clickedHandler 点击按钮的回掉
 @return NXAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                    otherBtns:(NSArray<NSString *> *)otherBtns
               clickedHandler:(NXAlertViewClickedHandler)clickedHandler;

/*
 * 点击 "完成" 回调
 *
 */
- (void)setClickedHandler:(NXAlertViewClickedHandler)clickedHandler;

/*
 * 点击 "取消" 回调
 *
 */
- (void)setCancelHandler:(NXAlertViewCancelHandler)cancelHandler;

/*
 * 即将显示回调
 *
 */
- (void)setWillPresentHandler:(NXAlertViewWillPresentHandler)willPresentHandler;

/*
 * 显示完成回调
 *
 */
- (void)setDidPresentHandler:(NXAlertViewDidPresentHandler)didPresentHandler;

/*
 * 即将消失回调
 *
 */
- (void)setWillDismissHandler:(NXAlertViewWillDismissHandler)willDismissHandler;

/*
 * 消失完成回调
 *
 */
- (void)setDidDismissHandler:(NXAlertViewDidDismissHandler)didDismissHandler;

/**
 Called after edits in any of the default fields added by the style

 @param shouldEnableHandler 输入字符后 回调
 */
- (void)setShouldEnableHandler:(NXAlertViewShouldEnableHandler)shouldEnableHandler;

@end

