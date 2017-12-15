//
//  NXSlider.h
//  QYDemo
//
//  Created by liuming on 2017/12/14.
//  Copyright © 2017年 yoyo. All rights reserved.
//

/**
 扩展 UISlider 添加自定义设置滑杆左边、右边图片的显示区域，自定义滑杆的显示高度

 e.g.
 NXSlider * slider=[[NXSlider alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
 [slider setThumbImage:[UIImage imageNamed:@"icon_huadong"]
 forState:UIControlStateNormal];
 slider.delegate= self;
 slider.minimumTrackTintColor = [UIColor redColor];
 slider.maximumTrackTintColor = [UIColor blueColor];
 [self.view addSubview:slider];
 
 //如果要自定义高度重写此方法
 - (CGRect)trackRectForBounds:(CGRect)bounds
 {
    return CGRectMake(0, (bounds.size.height - 10.0f)/2.0f, bounds.size.width, 10.0f);
 }
 */

#import <UIKit/UIKit.h>

@protocol NXSliderDelegate <NSObject>

/**
 自定义滑杆左边图片显示的高度
 */
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds;
/**
 自定义滑杆右边图片显示的高度
 */
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;

/**
 自定义滑杆的高度
 */
- (CGRect)trackRectForBounds:(CGRect)bounds;

@end

@interface NXSlider : UISlider

@property(nonatomic,weak)id<NXSliderDelegate> delegate;

@end
