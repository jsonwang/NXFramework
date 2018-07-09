//
//  NXAVUtil.m
//  OpenGLVideoMerge
//
//  Created by AK on 2017/4/17.
//  Copyright © 2017年 Tuo. All rights reserved.
//

#import "NXAVUtil.h"
#import "UIImage+NXCategory.h"

@implementation NXAVUtil


+ (CGSize)aptSize:(CGSize)size
{
    int ft = (int)size.width%16;
    if (ft!=0)
    {
        int num = (int)size.width/16;
        double w = num * 16;
        double h = num*16*size.height/size.width;
        h = ((int)h)%2 == 0? (int)h:(int)h-1;
        return CGSizeMake(w,h);
        
    }
    //宽度是 16的倍数时, 处理一下高度的 奇数问题
    size.height = ((int)size.height)%2 == 0? (int)size.height:(int)size.height-1;
    
    return size;

}

+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image
                                      size:(CGSize)imageSize
{
    //XXXXX 如果原图宽度不是16的位数,则缩放原图到16的倍数,
   
    //1,图片的归到16的倍数
    CGSize aptImageSize = [NXAVUtil aptSize:image.size];
    if (!CGSizeEqualToSize(image.size, aptImageSize))
    {
        NSLog(@"原图大小宽度不是16的倍数 %@",NSStringFromCGSize(image.size));
        
        image = [image nx_scaleToSize:aptImageSize];
    
        NSLog(@"归16后大小 %@",NSStringFromCGSize(image.size));
    }
    //2,指定输出的大小归到16的倍数
    imageSize = [NXAVUtil aptSize:imageSize];

   
    CGImageRef  imageRef = image.CGImage;
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    //@see 图片解压缩对比 http://blog.leichunfeng.com/blog/2017/02/20/talking-about-the-decompression-of-the-image-in-ios/
    //@see http://blog.csdn.net/jymn_chen/article/details/18645203
    //创建颜色空间
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    /*
     data   指向要渲染的绘制内存的地址。这个内存块的大小至少是（bytesPerRow*height）个字节
     width   bitmap的宽度,单位为像素
     height  bitmap的高度,单位为像素
     bitsPerComponent        内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     bytesPerRow     bitmap的每一行在内存所占的比特数
     colorspace              bitmap上下文使用的颜色空间。
     bitmapInfo       指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符
     */
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGRect rect = CGRectMake((imageSize.width - CGImageGetWidth(imageRef))/2.,
                            (imageSize.height - CGImageGetHeight(imageRef))/2.,
                            CGImageGetWidth(imageRef),
                            CGImageGetHeight(imageRef));
    
    CGContextDrawImage(context, rect, imageRef);
    
    //release C对象 它是不受ARC管理可以用CFGetRetainCount来查看当前引用计数  如,CFGetRetainCount(rgbColorSpace)
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (CVPixelBufferRef)crossFadeImage:(UIImage *)baseImage
                           toImage:(UIImage *)fadeInImage
                            atSize:(CGSize)imageSize
                         withAlpha:(CGFloat)alpha
{
    
    //1,图片1的归到16的倍数
    CGSize aptBaseImageSize = [NXAVUtil aptSize:baseImage.size];
    if (!CGSizeEqualToSize(baseImage.size, aptBaseImageSize))
    {
        baseImage = [baseImage nx_scaleToSize:aptBaseImageSize];
    }
    //2,图片2的归到16的倍数
    CGSize aptFadeImageSize = [NXAVUtil aptSize:baseImage.size];
    if (!CGSizeEqualToSize(baseImage.size, aptFadeImageSize))
    {
        fadeInImage = [fadeInImage nx_scaleToSize:aptFadeImageSize];
    }
    //3,指定输出的大小归到16的倍数
    imageSize = [NXAVUtil aptSize:imageSize];
    
    
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGRect drawRect = CGRectMake(0 + (imageSize.width-CGImageGetWidth(baseImage.CGImage))/2,
                                 (imageSize.height-CGImageGetHeight(baseImage.CGImage))/2,
                                 CGImageGetWidth(baseImage.CGImage),
                                 CGImageGetHeight(baseImage.CGImage));
    
    CGContextDrawImage(context, drawRect, baseImage.CGImage);
    
    CGContextBeginTransparencyLayer(context, nil);
    CGContextSetAlpha( context, alpha );
    CGContextDrawImage(context, drawRect, fadeInImage.CGImage);
    CGContextEndTransparencyLayer(context);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (UIImage *)imageFromCVPixelBufferRef:(CVPixelBufferRef)pixelBuffer
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return image;
}

@end
