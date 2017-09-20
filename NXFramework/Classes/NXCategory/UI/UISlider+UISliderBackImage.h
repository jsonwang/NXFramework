//
//  UISlider+UISlider_backImage.h
//  NXLib
//
//  Created by AK on 14-3-17.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (UISlider_backImage)

/*
 * 自定义UISlider的样式和滑块图片
 *
 * @param thumbImage 滑块图片
 * @param minimumTrackImage 左侧轨的图片
 * @param maximumTrackImage 右侧轨的拖图片
 *
 */
- (void)nx_setTrackImageAndThumbImage:(UIImage *)thumbImage
                    minimumTrackImage:(UIImage *)minimumTrackImage
                    maximumTrackImage:(UIImage *)maximumTrackImage;

@end
