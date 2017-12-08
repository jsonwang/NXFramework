//
//  NXSegmentView.h
//  NXlib
//
//  Created by AK on 2016/12/5.
//  Copyright © 2016年 yoyo. All rights reserved.
//

/**底部横线高度*/
#define BottomLineHeight 2

#import <UIKit/UIKit.h>

@class NXSegmentView;

@protocol NXSegmentViewDelegate<NSObject>

@optional
/**
 *  点击横向点击事件
 *
 *  @param sengment sengment对象
 *  @param index    点击的索引
 */
- (void)segment:(NXSegmentView *)sengment didSelectColumnIndex:(NSInteger)index selectColumStr:(NSString *)columStr;

@end

@interface NXSegmentView : UIView

@property(nonatomic, strong) NSArray *titleArry;

/** 未选中时的文字颜色 ,默认颜色DDMColor(80, 80, 80);*/
@property(nonatomic, strong) UIColor *titleColorNormal;

/**选中时的文字颜色，默认颜色DDMColor(30, 137, 255)*/
@property(nonatomic, strong) UIColor *titleColorSelect;

/**
 view 背景颜色 默认白色
 */
@property(nonatomic,strong) UIColor * bgColor;
/**
 未选择标题的下边线的颜色
 */
@property(nonatomic, strong) UIColor *lineColorNormal;

/**
 选择标题的下边线的颜色
 */
@property(nonatomic, strong) UIColor *lineColorSelect;


/**字体大小，默认15*/
@property(nonatomic, strong) UIFont *titleFont;


/**
 标题框是否等分，默认YES
 */
@property (nonatomic,assign)BOOL isBarEqualParts;

/**
 相邻两个item之间的间距，isBarEqualParts 为NO时候生效
 */
@property (nonatomic,assign)double itemMargin;

/**默认选中的index=1，即第一个*/
@property(nonatomic, assign) NSInteger defaultIndex;

@property(nonatomic, weak) id<NXSegmentViewDelegate> delegate;

//- (instancetype)initWithOrgin:(CGPoint)origin andHeight:(CGFloat)height;

/**
 segment移动到指定的 目标。默认开启移动动画

 @param selectIndex 目标标题索引
 @param types 是否有下划线
 */
- (void)scrollMenuViewSelectedoffsetX:(NSInteger)selectIndex withOffsetType:(BOOL)types;

/**
 segment移动到指定的 目标。

 @param selectIndex selectIndex 目标标题索引
 @param types 是否有下划线
 @param animation 是否有移动动画
 */
- (void)scrollMenuViewSelectedoffsetX:(NSInteger)selectIndex
                       withOffsetType:(BOOL)types
                        withAnimation:(BOOL)animation;

/**修改下划线和控制器*/
- (void)selectDefaultBottomAndVC:(NSInteger)defaultIndex;

/**
 选中 第defaultIndex个sengemt defaultIndex 从1开始

 @param defaultIndex 指定
 @param animation 是否有动画
 */
- (void)selectDefaultBottomAndVC:(NSInteger)defaultIndex
                   withAnimation:(BOOL)animation;

- (void)resetFrame:(CGRect )rect;

@end

