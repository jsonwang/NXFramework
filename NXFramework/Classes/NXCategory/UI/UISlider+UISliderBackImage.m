//
//  UISlider+UISlider_backImage.m
//  NXLib
//
//  Created by AK on 14-3-17.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "UISlider+UISliderBackImage.h"

@implementation UISlider (UISliderBackImage)

- (void)nx_setTrackImageAndThumbImage:(UIImage *)thumbImage
                    minimumTrackImage:(UIImage *)minimumTrackImage
                    maximumTrackImage:(UIImage *)maximumTrackImage
{
    [self setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:maximumTrackImage forState:UIControlStateNormal];

    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

@end
