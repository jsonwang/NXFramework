//
//  UIImage+UIImage_NXCategory.m
//  AKImovie
//
//  Created by AK on 16/2/21.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "UIImage+NXCategory.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (NXCategory)

#pragma mark - blur 效果
+ (UIImage *)nx_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(blur), nil];

    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

+ (UIImage *)nx_boxblurImage:(UIImage *)toBlurImage
{
    UIImage *newImage =

        [toBlurImage nx_scaleToSize:CGSizeMake(toBlurImage.size.width / 2., toBlurImage.size.height / 2.)];

    NSData *jpgData = UIImageJPEGRepresentation(newImage, 0.01);

    UIImage *image = [UIImage imageWithData:jpgData];
    CGFloat blur = 0.3f;

    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;

    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;

    // create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);

    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);

    // create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

    if (pixelBuffer == NULL) NSLog(@"No pixelbuffer");

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    // perform convolution
    error =
        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
            ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
                   ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL,
                                                 kvImageEdgeExtend);

    if (error)
    {
        NSLog(@"error from convolution %ld", error);
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes,
                                             colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    // clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);

    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);

    return returnImage;
}

#pragma mark - 旋转
+ (UIImage *)nx_fixOrientation:(UIImage *)aImage isFront:(BOOL)isFront;
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    if (isFront)
    {
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }

    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the
    // transform
    // calculated above.
    CGContextRef ctx =
        CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage),
                              0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 旋转
+ (UIImage *)nx_rotationImage:(UIImage *)image orientation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;

    switch (orientation)
    {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);

    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);

    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"image size %f---%f", image.size.width, image.size.height);
    UIGraphicsEndImageContext();
    return newPic;
}

#pragma mark - 缩放
- (UIImage *)nx_scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;

    float radio = 1;
    if (verticalRadio > 1 && horizontalRadio > 1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }

    width = width * radio;
    height = height * radio;

    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}

//按照最短边缩放 maxlength 边长最大值
- (UIImage *)nx_scaleWithMaxLength:(float)maxLength
{
    if (self.size.width > maxLength || self.size.height > maxLength)
    {
        float maxWidth = maxLength;
        float maxHeight = maxLength;

        if (self.size.width != self.size.height)
        {
            if (self.size.width > self.size.height)
            {
                //按照宽 来缩放
                float imageScale = maxLength / self.size.width;
                maxHeight = self.size.height * imageScale;
            }
            else if (self.size.width < self.size.height)
            {
                float imageScale = maxLength / self.size.height;

                maxWidth = self.size.width * imageScale;
            }
        }
        // 返回新的改变大小后的图片
        return [self nx_scaleToSize:CGSizeMake(maxWidth, maxHeight)];
    }

    return self;
}

#pragma mark - 截取
- (UIImage *)nx_imageByCroppingWithStyle:(NXCropImageStyle)style
{
    CGRect rect = CGRectZero;
    switch (style)
    {
        case NXCropImageStyleLeft:
            rect = CGRectMake(0, 0, self.size.width / 2, self.size.height);
            break;
        case NXCropImageStyleCenter:
            rect = CGRectMake(self.size.width / 4, 0, self.size.width / 2, self.size.height);
            break;
        case NXCropImageStyleRight:
            rect = CGRectMake(self.size.width / 2, 0, self.size.width / 2, self.size.height);
            break;
        case NXCropImageStyleLeftOneOfThird:
            rect = CGRectMake(0, 0, self.size.width / 3, self.size.height);
            break;
        case NXCropImageStyleCenterOneOfThird:
            rect = CGRectMake(self.size.width / 3, 0, self.size.width / 3, self.size.height);
            break;
        case NXCropImageStyleRightOneOfThird:
            rect = CGRectMake(self.size.width / 3 * 2, 0, self.size.width / 3, self.size.height);
            break;
        case NXCropImageStyleLeftQuarter:
            rect = CGRectMake(0, 0, self.size.width / 4, self.size.height);
            break;
        case NXCropImageStyleCenterLeftQuarter:
            rect = CGRectMake(self.size.width / 4, 0, self.size.width / 4, self.size.height);
            break;
        case NXCropImageStyleCenterRightQuarter:
            rect = CGRectMake(self.size.width / 4 * 2, 0, self.size.width / 4, self.size.height);
            break;
        case NXCropImageStyleRightQuarter:
            rect = CGRectMake(self.size.width / 4 * 3, 0, self.size.width / 4, self.size.height);
            break;
        default:
            break;
    }

    return [self imageByCroppingWithRect:rect];
}

- (UIImage *)imageByCroppingWithRect:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}

- (UIImage *)nx_cropImageToSquare{

    if(self.size.width == self.size.height){
        
        return self;
    }
    double w = self.size.width;
    double h = self.size.height;
    double m = MIN(w, h);
    double tx = 0;
    double ty = 0;
    if(w <= h)
    {
        tx = 0;
        ty =(h - w)/2.0;
        
    } else{
    
        tx = (w - h)/2.0f;
        ty = 0;
    }
    return [self imageByCroppingWithRect:CGRectMake(tx, ty, m, m)];
}

- (UIImage *)nx_zoomWithSize:(CGSize)size{

    if(self == nil)
    {
        return nil;
    }
    
    double w  = self.size.width;
    double h =self.size.height;
    double vRatio = w / size.width;
    double hRatio = h / size.height;
    double ratio = MAX(vRatio, hRatio);
    w /= ratio;
    h /= ratio;
    CGRect drawRect = CGRectMake((size.width - w)/2.0f , (size.height - h)/2.0f, w, h);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:drawRect];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return  scaledImage;
    
}


- (UIImage *)nx_zoomImageToSquare
{
    if (self == nil)
    {
        return nil;
    }
    double tw = MIN(self.size.width, self.size.height);

    return [self nx_scaleToSize:CGSizeMake(tw, tw)];
}

//截屏 有透明的
+ (UIImage *)nx_screenHierarchyShots:(UIView *)view { return [UIImage nx_screenHierarchyShots:view isOpaque:NO]; }
//高清截屏 opaque 是否有透明图层
+ (UIImage *)nx_screenHierarchyShots:(UIView *)view isOpaque:(BOOL)opaque
{
    // size——同UIGraphicsBeginImageContext
    // opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    // scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 获得裁剪后的图片
+ (UIImage *)nx_cropImageView:(UIImageView *)imageView
                       toRect:(CGRect)rect
                    zoomScale:(double)zoomScale
                containerView:(UIView *)containerView
                   outputWith:(CGFloat)outputWith
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    // 平移的处理
    CGRect imageViewRect = [imageView convertRect:imageView.bounds toView:containerView];
    CGPoint point = CGPointMake(imageViewRect.origin.x + imageViewRect.size.width / 2,
                                imageViewRect.origin.y + imageViewRect.size.height / 2);

    CGPoint zeroPoint =
        CGPointMake(CGRectGetWidth(containerView.frame) / 2., CGRectGetHeight(containerView.frame) / 2.);

    CGPoint translation = CGPointMake(point.x - zeroPoint.x, point.y - zeroPoint.y);
    transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
    // 缩放的处理
    transform = CGAffineTransformScale(transform, zoomScale, zoomScale);

    CGImageRef imageRef = [self nx_newTransformedImage:transform
                                           sourceImage:imageView.image.CGImage
                                            sourceSize:imageView.image.size
                                           outputWidth:outputWith
                                              cropSize:rect.size
                                         imageViewSize:imageView.frame.size];
    UIImage *cropedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropedImage;
}

+ (CGImageRef)nx_newTransformedImage:(CGAffineTransform)transform
                         sourceImage:(CGImageRef)sourceImage
                          sourceSize:(CGSize)sourceSize
                         outputWidth:(CGFloat)outputWidth
                            cropSize:(CGSize)cropSize
                       imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self nx_newScaledImage:sourceImage toSize:sourceSize];

    CGFloat aspect = cropSize.height / cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth * aspect);

    CGContextRef context =
        CGBitmapContextCreate(NULL, outputSize.width, outputSize.height, CGImageGetBitsPerComponent(source), 0,
                              CGImageGetColorSpace(source), CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));

    CGAffineTransform uiCoords =
        CGAffineTransformMakeScale(outputSize.width / cropSize.width, outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width / 2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);

    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(-imageViewSize.width / 2, -imageViewSize.height / 2.0, imageViewSize.width,
                                           imageViewSize.height),
                       source);
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

+ (CGImageRef)nx_newScaledImage:(CGImageRef)source toSize:(CGSize)size
{
    CGSize srcSize = size;
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(rgbColorSpace);

    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);

    CGContextDrawImage(context, CGRectMake(-srcSize.width / 2, -srcSize.height / 2, srcSize.width, srcSize.height),
                       source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return resultRef;
}

#pragma mark - 圆角
+ (UIImage *)nx_circleImage:(UIImage *)img
{
   return [self nx_circleImage:img cuttingDirection:UIRectCornerAllCorners cornerRadii:img.size.height/2. borderWidth:0 borderColor: [UIColor clearColor] backgroundColor: [UIColor clearColor]];
}

+ (UIImage *)nx_circleImage:(UIImage *)image cuttingDirection:(UIRectCorner)direction cornerRadii:(CGFloat)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor
{
    //处理后的数据
    UIImage * newImage = nil;
    if (image.size.height != 0 && image.size.width != 0)
    {
        if (cornerRadii == 0)
        {
            cornerRadii = image.size.height / 2;
        }
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        CGContextRef currnetContext = UIGraphicsGetCurrentContext();
        if (currnetContext) {
            
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:direction cornerRadii:CGSizeMake(cornerRadii - borderWidth, cornerRadii - borderWidth)];
            CGContextAddPath(currnetContext,path.CGPath);
            CGContextClip(currnetContext);
            
            [image drawInRect:rect];
            [borderColor setStroke];// 画笔颜色
            [backgroundColor setFill];// 填充颜色
            [path stroke];
            [path fill];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        return newImage;
    }
    
    return newImage;
}

+ (UIImage *)nx_launchImage
{
    CGSize viewSize  = [UIScreen mainScreen].bounds.size;
    
    NSString * viewOrientation = @"Portrait";
    NSString * launchImageName = nil;
    NSArray * imageDict = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"UILaunchImages"];
    for (NSDictionary  * dict in imageDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    
    return launchImage;
}


+ (UIImage*)transparentBackClear:(UIImage*)image color:(UIColor*)color
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {
            
            // 此处把白色背景颜色给变为透明
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
            
        }else{
            
            // 改成下面的代码，会将图片转成想要的
            //            uint8_t* ptr = (uint8_t*)pCurPtr;
            //
            //            ptr[3] = 0; //0~255
            //
            //            ptr[2] = 0;
            //
            //            ptr[1] = 0;
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

@end
