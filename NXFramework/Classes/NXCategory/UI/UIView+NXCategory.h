//
//  UIView+UIView_RoundedCorners.h
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NXCategory)

#pragma mark - Deprecated
/**
 * NS_DEPRECATED 兼容旧版本,不建议使用.以后使用 nx_x 或 left_sd
 */
@property float x __deprecated_msg("兼容旧版本,不建议使用.以后使用 `nx_x` 或 `left_sd`");

/**
 *  NS_DEPRECATED 兼容旧版本,不建议使用.以后使用 nx_y 或 top_sd
 */
@property float y __deprecated_msg("兼容旧版本,不建议使用.以后使用 `nx_y` 或 `top_sd`");

@property float nx_x;
@property float nx_y;
@property float nx_width;
@property float nx_height;

@property CGFloat nx_top;
@property CGFloat nx_bottom;

@property(nonatomic, readonly) CGPoint nx_middle;

@property(nonatomic, readonly) CGSize nx_orientationSize;
@property(nonatomic, readonly) CGFloat nx_orientationWidth;
@property(nonatomic, readonly) CGFloat nx_orientationHeight;
@property(nonatomic, readonly) CGPoint nx_orientationMiddle;

/**
 *  设置view 的string tag
 *
 *  @param tag view tag
 */
- (void)nx_setStringTag:(NSString *)tag;

/**
 *  根据tag 取view
 *
 *  @param tag view tag
 *
 *  @return view
 */
- (UIView *)nx_getViewWithStringTag:(NSString *)tag;

#pragma mark - Border radius

/**
 *  @brief 设置圆角
 *
 *  @param cornerRadius 圆角半径
 */
- (void)nx_rounded:(CGFloat)cornerRadius;

/**
 *  @brief 设置圆角和边框
 *
 *  @param cornerRadius 圆角半径
 *  @param borderWidth  边框宽度
 *  @param borderColor  边框颜色
 */
- (void)nx_rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 *  @brief 设置边框
 *
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (void)nx_border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 *  控制性圆角（如左上、右下等)
 *
 *  @param corners 方位可多值 UIRectCornerTopRight | UIRectCornerTopLeft
 *  @param size    大小
 */
- (void)nx_setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size;

/** 设置UIView、UIButton和UILabel圆角,本方法会防止发生离屏渲染,当圆角视图非常多时建议使用, 比如在tableview中 设置圆角时 @see https://objccn.io/issue-3-1/
 * @param view 需要进行切割的对象
 * @param direction 切割的方向
 * @param cornerRadii 圆角半径
 * @param borderWidth 边框宽度
 * @param borderColor 边框颜色
 * @param backgroundColor 背景色
 */
- (void)nx_circleView:(UIView *)view
      cuttingDirection:(UIRectCorner)direction
           cornerRadii:(CGFloat)cornerRadii
           borderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor
       backgroundColor:(UIColor *)backgroundColor;

#pragma mark - Animation

/**
 *  跟随键盘动画
 *
 *  @param userInfo 键盘动画info dictionary
 *  @param animations 执行动画
 *  @param completion 动画结束执行方法
 *
 */
+ (void)nx_animateFollowKeyboard:(NSDictionary *)userInfo
                      animations:(void (^)(NSDictionary *userInfo))animations
                      completion:(void (^)(BOOL finished))completion;

#pragma mark - Public Method
/**
 *  当前第一响应者
 *
 */
- (UIView *)nx_firstResponder;

@end
