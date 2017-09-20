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
 
 CGImageRef to CVPixelBufferRef
 @param image CGImageRef
 @param imageSize 指定大小
 @return 返回 CVPixelBufferRef
 */
+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
                                      size:(CGSize)imageSize;

+ (CVPixelBufferRef)crossFadeImage:(CGImageRef)baseImage
                           toImage:(CGImageRef)fadeInImage
                            atSize:(CGSize)imageSize
                         withAlpha:(CGFloat)alpha;
@end
