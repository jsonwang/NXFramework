//
//  FreakyCreateUITool.h
//  Freaky
//
//  Created by 王成 on 14-8-3.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NXCreateUITool : NSObject

/**
 生成一个 UILable

 @param frame 坐标
 @param backColor 背景色
 @param alignment 对齐方式
 @param text 文字
 @param textColor 文字颜色
 @param font 字体
 @param superView 父视图
 @return UILable
 */
+ (UILabel *)createLabelInitWithFrame:(CGRect)frame
                      backgroundColor:(UIColor *)backColor
                        textAlignment:(NSTextAlignment)alignment
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                            superView:(UIView *)superView;
/**
 生成一个 UIImageView size为指定的图片size

 @param point 坐标
 @param fileName 图片名称
 @param superView 父视图
 @return UIImageView
 */
+ (UIImageView *)createImageViewWithPoint:(CGPoint)point fileName:(NSString *)fileName superView:(UIView *)superView;

/**
 生成一个 UIButton size为指定的normal状态图片size

 @param point 坐标
 @param normalImageFileName 正常态图片
 @param highlightFileName 高亮态图片
 @param superView 父视图
 @return UIButton
 */
+ (UIButton *)createButtonWithPoint:(CGPoint)point
                normalImageFileName:(NSString *)normalImageFileName
                  highlightFileName:(NSString *)highlightFileName
                          superView:(UIView *)superView;
/**
 生成一个 UIButton

 @param rect 坐标
 @param superView 父视图
 @return UIButton
 */
+ (UIButton *)createButtonWithRect:(CGRect)rect superView:(UIView *)superView;

/**
 生成一个 UIButton 大小固定为 64 * 44

 @param point 坐标
 @param titleStr 标题
 @param superView 父视图
 @return UIButton
 */
+ (UIButton *)createTextButtonWithPoint:(CGPoint)point title:(NSString *)titleStr superView:(UIView *)superView;

/**
 生成一个纵向 image + text的UIButton

 @param rect 坐标
 @param imageName 图片名称
 @param title 标题
 @param superView 父视图
 @return UIButton
 */
+ (UIButton *)createTextAndImageButtonWithRect:(CGRect)rect
                                         image:(NSString *)imageName
                                          text:(NSString *)title
                                     superView:(UIView *)superView;

/**
 生成一个横向 image + text的UIButton

 @param imageName 图片名称
 @param title 标题
 @param rect 坐标
 @param superView 父视图
 @return UIButton
 */
+ (UIButton *)createButtonWithImage:(NSString *)imageName
                               text:(NSString *)title
                               rect:(CGRect)rect
                          superView:(UIView *)superView;

/**
 横向分割线 宽度为屏幕宽度 高度为0.5

 @param point 坐标
 @param superView 父视图
 @return 分割线
 */
+ (UIImageView *)createSeparatorLineWithPoint:(CGPoint)point superView:(UIView *)superView;

/**
 垂直分割线 宽度为0,5

 @param point 坐标
 @param height 高度
 @param superView 父识图
 @return 分割线
 */
+ (UIImageView *)createVerticalLineWithPoint:(CGPoint)point height:(float)height superView:(UIView *)superView;

/**
 生成一个按钮为文字的UIBarButtonItem size固定

 @param name 标题
 @param target target
 @param action 点击事件
 @param isleft 是否是左侧按钮
 @param font 字体
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)navigationItemWithNameString:(NSString *)name
                                           Target:(id)target
                                           action:(SEL)action
                                           isleft:(BOOL)isleft
                                             font:(UIFont *)font;

/**
  生成一个按钮为图片的 UIBarButtonItem size为传入图片size

 @param naviImage 正常态图片
 @param hightLightedImage 高亮态图片
 @param target target
 @param action 点击事件
 @param isleft 是否是左侧按钮
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)navigationItemBackImage:(UIImage *)naviImage
                                 highlighted:(UIImage *)hightLightedImage
                                      Target:(id)target
                                      action:(SEL)action
                                      isLeft:(BOOL)isleft;

/*
 *
 * 生成页面标题栏
 * @param title 页面标题
 *
 */
+ (UILabel *)setNavigationItmeTitleView:(NSString *)title;
 
@end
