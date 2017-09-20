//
//  NXPageControl.h
//  ZhongTouBang
//
//  Created by AK on 7/16/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

/*
   自定义UIPageControl圆点大小、以图片展示
    e.g.
 */
#import <UIKit/UIKit.h>

@interface NXPageControl : UIPageControl

@property(nonatomic, assign, readonly) BOOL firstPage;
@property(nonatomic, assign, readonly) BOOL lastPage;

/**
 *  如果直接使用init初始化、可以手动定义以下属性
 *  其中pageSize为空则跟随图片size
 */
@property(nonatomic) UIImage *currentImage;    //高亮图片
@property(nonatomic) UIImage *defaultImage;    //默认图片
@property(nonatomic, assign) CGSize pageSize;  //图标大小

/**
  初始化方法

 @param frame 大小
 @param currentImage 选中图片
 @param defaultImage 默认图片
 @return UIPageControl 对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                 currentImage:(UIImage *)currentImage
              andDefaultImage:(UIImage *)defaultImage;

@end
