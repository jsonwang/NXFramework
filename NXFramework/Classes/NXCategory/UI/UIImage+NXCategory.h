//
//  UIImage+UIImage_NXCategory.h
//  AKImovie
//
//  Created by AK on 16/2/21.
//  Copyright © 2016年 ak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NXCropImageStyle) {
    NXCropImageStyleRight = 0,               // 右半部分
    NXCropImageStyleCenter = 1,              // 中间部分
    NXCropImageStyleLeft = 2,                // 左半部分
    NXCropImageStyleRightOneOfThird = 3,     // 右侧三分之一部分
    NXCropImageStyleCenterOneOfThird = 4,    // 中间三分之一部分
    NXCropImageStyleLeftOneOfThird = 5,      // 左侧三分之一部分
    NXCropImageStyleRightQuarter = 6,        // 右侧四分之一部分
    NXCropImageStyleCenterRightQuarter = 7,  // 中间右侧四分之一部分
    NXCropImageStyleCenterLeftQuarter = 8,   // 中间左侧四分之一部分
    NXCropImageStyleLeftQuarter = 9,         // 左侧四分之一部分
};

@interface UIImage (NXCategory)

#pragma mark - blur 效果
/**
 给图片打马赛克
 @param image 原始图片
 @param blur 值越 blurry 就越大
 @return 处理后的图片
 */
+ (UIImage *)nx_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
  boxblur image 这个要在整理

  @param toBlurImage 要处理的图片
  @return 处理后图片
 */
+ (UIImage *)nx_boxblurImage:(UIImage *)toBlurImage;

#pragma mark - 旋转
/**
  照片旋转90度,如从系统相册中取出的原图要转正

 @param aImage 原图
 @param isFront YES 为前置拍照
 @return 转正后图片
 */
+ (UIImage *)nx_fixOrientation:(UIImage *)aImage isFront:(BOOL)isFront;

/**
 旋转图片

 @param image 原图
 @param orientation 旋转的方向
 @return 旋转后的图片
 */
+ (UIImage *)nx_rotationImage:(UIImage *)image orientation:(UIImageOrientation)orientation;

#pragma mark - 缩放
/**
 等比缩放图片

 @param size 放到的大小(单位为像素)
 @return 处理后的图片
 */
- (UIImage *)nx_scaleToSize:(CGSize)size;

/**
 等比缩放图片 按照最短边缩放
 @param maxLength 边长最大值 (单位为像素)
 @return 处理后的图片
 */
- (UIImage *)nx_scaleWithMaxLength:(float)maxLength;

#pragma mark - 截取
/**
 截取 uiimage 指定区域

 @param style 类型为 NXCropImageStyle
 @return 裁剪后的图片
 */
- (UIImage *)nx_imageByCroppingWithStyle:(NXCropImageStyle)style;

/**
  截取 uiimage 指定区域

 @param rect 裁剪区域
 @return 裁剪后的图片
 */
- (UIImage *)imageByCroppingWithRect:(CGRect)rect;


/**
 将图片按照最短边等比截取图片中间部分

 @return 截取后到正方形图片
 */
- (UIImage *)nx_cropImageToSquare;

/**
 *  将图片等比绘制到正方形画布中并重新生成新图
 *
 *  @return 处理后的图片
 */
- (UIImage *)nx_zoomImageToSquare;

/**
 高清截屏 opaque 为no 有透明度速度会慢一些

 @param view 指定的VIEW
 @return 截屏图片
 */
+ (UIImage *)nx_screenHierarchyShots:(UIView *)view;

/**
 高清截屏

 @param view 指定的VIEW
 @param opaque 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
 @return 截屏图片
 */
+ (UIImage *)nx_screenHierarchyShots:(UIView *)view isOpaque:(BOOL)opaque;

/**
 获得裁剪图片

 e.g.
 int squalWidth = MIN(self.clipImage.size.width, self.clipImage.size.height);

 float clipX = _clipScroll.contentOffset.x;
 float clipY = _clipScroll.contentOffset.y;
 CGRect rect = CGRectMake(clipX, clipY, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_WIDTH);

 clipedImage =
 [UIImage nx_cropImageView:_bigImageView toRect:rect zoomScale:1
 containerView:_backView outputWith:squalWidth];

 @param imageView 原始VIEW
 @param rect 截取区域
 @param zoomScale 缩放大小
 @param containerView 显示区域VIEW
 @param outputWith 输出大小
 @return 处理后图片
 */
+ (UIImage *)nx_cropImageView:(UIImageView *)imageView
                       toRect:(CGRect)rect
                    zoomScale:(double)zoomScale
                containerView:(UIView *)containerView
                   outputWith:(CGFloat)outputWith;

#pragma mark - 圆角
/**
 切圆角 可防止离屏渲染
 e.g.
 UIImage *placeHolder = [[UIImage imageNamed:@"userIcon"] circleImage];

 @param img 原图片
 @return 处理后的图片
 */
+ (UIImage *)nx_circleImage:(UIImage *)img;

/** 切圆角 可防止离屏渲染
 * @param image 需要进行圆角的图片
 * @param direction 切割的方向
 * @param cornerRadii 圆角半径
 * @param borderWidth 边框宽度
 * @param borderColor 边框颜色
 * @param backgroundColor 背景色
 * @return 处理后的图片
 */
+ (UIImage *)nx_circleImage:(UIImage *)image cuttingDirection:(UIRectCorner)direction cornerRadii:(CGFloat)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;

/**
 获取当前屏幕大小的的开屏页图片
 
 @return 开屏页图片
 */
+ (UIImage *)nx_launchImage;


/**
 把指定颜色背景变成透明

 @param image 原图数据
 @param color 原背景色
 @return 背景透明后的图
 */
+ (UIImage*)transparentBackClear:(UIImage*)image color:(UIColor*)color;

@end
