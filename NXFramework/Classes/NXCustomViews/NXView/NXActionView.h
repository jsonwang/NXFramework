//
//  NXActionView.h
//  NXlib
//
//  Created by AK on 9/19/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXView.h"

typedef BOOL (^NXActionViewWillTapCancelHandler)(void);
typedef void (^NXActionViewDidTapCancelHandler)(void);

typedef NS_ENUM(NSUInteger, NXViewActionAnimations) {
    NXViewActionAnimationActionSheet,
    NXViewActionAnimationAlert,
};

@interface NXActionView : NXView

@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval delay;
@property(nonatomic, assign) UIViewAnimationOptions animationOptions;
@property(nonatomic, assign) NXViewActionAnimations actionAnimations;

@property(nonatomic, readonly, getter=isVisible) BOOL visible;

@property(nonatomic, copy) NXActionViewWillTapCancelHandler willTapCancelHandler;
@property(nonatomic, copy) NXActionViewDidTapCancelHandler didTapCancelHandler;

/**
 显示actionview

 @param view 指定显示actionview 的视图
 */
- (void)showInView:(UIView *)view;

/**
 移除actionview
 */
- (void)dismiss;

@end
