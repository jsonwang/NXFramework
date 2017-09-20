//
//  NXVideoToGIF.m
//  Philm
//
//  Created by AK on 2017/5/12.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXVideoToGIF.h"

// Declare constants
#define fileName @"NSGIF"
#define timeInterval @(600)
#define tolerance @(0.01)


@implementation NXVideoToGIF

+ (void)transformGIFWithURL:(NSURL*)videoURL loopCount:(int)loopCount completion:(NXGenericCallback)finishBlock;
{
    float delayTime = 0.02f;
    
    // Create properties dictionaries
    NSDictionary *fileProperties = [self filePropertiesWithLoopCount:loopCount];
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    
    float videoWidth = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].width;
    float videoHeight = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].height;

    // Get the length of the video in seconds
    float videoLength = (float)asset.duration.value / asset.duration.timescale;
    int framesPerSecond = 4;
    int frameCount = videoLength * framesPerSecond;
    
    // How far along the video track we want to move, in seconds.
    float increment = (float)videoLength / frameCount;
    
    // Add frames to the buffer
    NSMutableArray *timePoints = [NSMutableArray array];
    for (int currentFrame = 0; currentFrame < frameCount; ++currentFrame)
    {
        float seconds = (float)increment * currentFrame;
        CMTime time = CMTimeMakeWithSeconds(seconds,  [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0].nominalFrameRate);
        [timePoints addObject:[NSValue valueWithCMTime:time]];
    }
    
    // Prepare group for firing completion block
    dispatch_group_t gifQueue = dispatch_group_create();
    dispatch_group_enter(gifQueue);
    
    __block NSURL *gifURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        gifURL = [self createGIFforTimePoints:timePoints
                                      fromURL:videoURL
                               fileProperties:fileProperties
                              frameProperties:frameProperties
                                   frameCount:frameCount
                                      gifSize:CGSizeMake(videoWidth, videoHeight)];
        
        dispatch_group_leave(gifQueue);
    });
    
    dispatch_group_notify(gifQueue, dispatch_get_main_queue(), ^{
        
        NSLog(@"转换完成 %@",gifURL);
        // Return GIF URL
        if (finishBlock) {
            finishBlock(YES,gifURL);
        }
        
    });
}

#pragma mark - Base methods

+ (NSURL *)createGIFforTimePoints:(NSArray *)timePoints
                          fromURL:(NSURL *)url
                   fileProperties:(NSDictionary *)fileProperties
                  frameProperties:(NSDictionary *)frameProperties
                       frameCount:(int)frameCount
                          gifSize:(CGSize)gifSize
{
    NSString *timeEncodedFileName = [NSString
                                     stringWithFormat:@"%@-%lu.gif", fileName, (unsigned long)([[NSDate date] timeIntervalSince1970] * 10.0)];
    NSString *temporaryFile = [NSTemporaryDirectory() stringByAppendingString:timeEncodedFileName];
    NSURL *fileURL = [NSURL fileURLWithPath:temporaryFile];
    if (fileURL == nil) return nil;
    
    CGImageDestinationRef destination =
    CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, frameCount, NULL);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CMTime tol = CMTimeMakeWithSeconds([tolerance floatValue], [timeInterval intValue]);
    generator.requestedTimeToleranceBefore = tol;
    generator.requestedTimeToleranceAfter = tol;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    for (NSValue *time in timePoints)
    {
        CGImageRef imageRef;
    
        imageRef = [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
 
        
        if (error)
        {
            NSLog(@"Error copying image: %@", error);
        }
        if (imageRef)
        {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        }
        else if (previousImageRefCopy)
        {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        }
        else
        {
            NSLog(@"Error copying image and no previous frames to duplicate");
            return nil;
        }
        CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        CGImageRelease(imageRef);
    }
    CGImageRelease(previousImageRefCopy);
    
    // Finalize the GIF
    if (!CGImageDestinationFinalize(destination))
    {
        NSLog(@"Failed to finalize GIF destination: %@", error);
        if (destination != nil)
        {
            CFRelease(destination);
        }
        return nil;
    }
    CFRelease(destination);
    
    return fileURL;
}


CGImageRef createImageWithScale(CGImageRef imageRef, float scale)
{
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef) * scale, CGImageGetHeight(imageRef) * scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context)
    {
        return nil;
    }
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Release old image
    CFRelease(imageRef);
    // Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
#endif
    
    return imageRef;
}

#pragma mark - Properties

+ (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount
{
    return @{(NSString *)kCGImagePropertyGIFDictionary : @{(NSString *)kCGImagePropertyGIFLoopCount : @(loopCount)} };
}

+ (NSDictionary *)framePropertiesWithDelayTime:(float)delayTime
{
    return @{
             (NSString *)kCGImagePropertyGIFDictionary : @{(NSString *)kCGImagePropertyGIFDelayTime : @(delayTime)},
             (NSString *)kCGImagePropertyColorModel : (NSString *)kCGImagePropertyColorModelRGB
             };
}

@end
