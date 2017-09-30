//
//  NXAVUtil.h
//  OpenGLVideoMerge
//
//  Created by AK on 2017/4/17.
//  Copyright © 2017年 Tuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXAVUtil : NSObject
{

}


/**
  把指定 size 统一到16的位数

 @param size 原始大小
 @return 处理后的大小
 */
+ (CGSize)aptSize:(CGSize)size;
/**
 
 CGImageRef to CVPixelBufferRef
 @param image CGImageRef
 @param imageSize 指定大小
 @return 返回 CVPixelBufferRef 注意在返回的 buffer 不在使用的时候 调用 CVPixelBufferRef CVBufferRelease 析构
 */
+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image
                                      size:(CGSize)imageSize;


/**
 两个图片的过渡效果

 @param baseImage 原图片
 @param fadeInImage 过渡图片
 @param imageSize 图片大小
 @param alpha 透明度
 @return @return 返回合成后 CVPixelBufferRef 注意在返回的 buffer 不在使用的时候 调用 CVPixelBufferRef CVBufferRelease 析构
 */
+ (CVPixelBufferRef)crossFadeImage:(UIImage *)baseImage
                           toImage:(UIImage *)fadeInImage
                            atSize:(CGSize)imageSize
                         withAlpha:(CGFloat)alpha;
@end
