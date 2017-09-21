//
//  NXImage2Video.m
//  OpenGLVideoMerge
//
//  Created by AK on 2017/4/17.
//  Copyright © 2017年 Tuo. All rights reserved.
//

#import "NXImagesToVideo.h"
#import "NXAVUtil.h"
#import <NXAVAssetExportSession.h>
#import <AVFoundation/AVFoundation.h>
#import "NXFileManager.h"

//合并输出视频的文件名
#define NXImage2VideoName @"NXImage2Video.mp4"

NSInteger const DefaultFrameRate = 1;
NSInteger const TransitionFrameCount = 50;
NSInteger const FramesToWaitBeforeTransition = 40;

@implementation NXImagesToVideo

+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                   size:(CGSize)size
                      withCallbackBlock:(NXGenericCallback)callbackBlock;
{
    [NXImagesToVideo writeImageAsMovieWithImageNames:array toPath:@"" size:size fps:DefaultFrameRate animateTransitions:YES withCallbackBlock:callbackBlock];
}

+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                 toPath:(NSString *)savePath
                                   size:(CGSize)size
                      withCallbackBlock:(NXGenericCallback)callbackBlock;
{
    [NXImagesToVideo writeImageAsMovieWithImageNames:array toPath:savePath size:size fps:DefaultFrameRate animateTransitions:YES withCallbackBlock:callbackBlock];
}


+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                 toPath:(NSString *)savePath
                                   size:(CGSize)size
                                    fps:(int)fps
                     animateTransitions:(BOOL)shouldAnimateTransitions
                      withCallbackBlock:(NXGenericCallback)callbackBlock
{
    //设置输出文件路径
    savePath =
        savePath.length > 0 ? savePath : [[NXFileManager getCacheDir] stringByAppendingPathComponent:NXImage2VideoName];
    //如果文件存在 删除老数据
    unlink([savePath UTF8String]);

    NSLog(@"设置输出路径:%@", savePath);
    NSError *error = nil;
    AVAssetWriter *videoWriter =
        [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:savePath] fileType:AVFileTypeMPEG4 error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{

        if (error)
        {
            if (callbackBlock)
            {
                callbackBlock(NO, error);
            }
            return;
        }
    });
    
    NSParameterAssert(videoWriter);

    //设置输出视频的属性,size 为输出视频的宽高
    NSDictionary *videoSettings = @{
        AVVideoCodecKey : AVVideoCodecH264,
        AVVideoWidthKey : [NSNumber numberWithInt:size.width],
        AVVideoHeightKey : [NSNumber numberWithInt:size.height]
    };

    AVAssetWriterInput *writerInput =
        [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];

    AVAssetWriterInputPixelBufferAdaptor *adaptor =
        [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                         sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];

    // Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];

    CVPixelBufferRef buffer;
    CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &buffer);

    CMTime presentTime = CMTimeMake(0, fps);

    int i = 0;
    while (1)
    {
        if (writerInput.readyForMoreMediaData)
        {
            presentTime = CMTimeMake(i, fps);

            if (i >= [array count])
            {
                buffer = NULL;
            }
            else
            {
                buffer = [NXAVUtil pixelBufferFromCGImage:[[UIImage imageNamed:array[i]] CGImage]
                                                     size:size];
            }

            if (buffer)
            {
                // append buffer

                BOOL appendSuccess =
                    [NXImagesToVideo appendToAdapter:adaptor pixelBuffer:buffer atTime:presentTime withInput:writerInput];
                NSAssert(appendSuccess, @"Failed to append");

                //显示过渡效果
                if (shouldAnimateTransitions && i + 1 < array.count)
                {
                    // Create time each fade frame is displayed
                    CMTime fadeTime = CMTimeMake(1, fps * TransitionFrameCount);

                    // Add a delay, causing the base image to have more show time before fade begins.
                    for (int b = 0; b < FramesToWaitBeforeTransition; b++)
                    {
                        presentTime = CMTimeAdd(presentTime, fadeTime);
                    }

                    // Adjust fadeFrameCount so that the number and curve of the fade frames and their alpha stay
                    // consistant
                    NSInteger framesToFadeCount = TransitionFrameCount - FramesToWaitBeforeTransition;

                    // Apply fade frames
                    for (double j = 1; j < framesToFadeCount; j++)
                    {
                        buffer = [NXAVUtil crossFadeImage:[[UIImage imageNamed:array[i]] CGImage]
                                                  toImage:[[UIImage imageNamed:array[i + 1]] CGImage]
                                                   atSize:size
                                                withAlpha:j / framesToFadeCount];

                        BOOL appendSuccess = [NXImagesToVideo appendToAdapter:adaptor
                                                                pixelBuffer:buffer
                                                                     atTime:presentTime
                                                                  withInput:writerInput];
                        presentTime = CMTimeAdd(presentTime, fadeTime);

                        NSAssert(appendSuccess, @"Failed to append");
                    }
                }

                i++;
            }
            else
            {
                // Finish the session:
                [writerInput markAsFinished];

                [videoWriter finishWritingWithCompletionHandler:^{
                    NSLog(@"Successfully closed video writer");

                    dispatch_async(dispatch_get_main_queue(), ^{

                        NSLog(@"导出视频结果 %ld 路径: %@", (long)videoWriter.status, savePath);
                        if (videoWriter.status == AVAssetWriterStatusCompleted)
                        {
                            if (callbackBlock)
                            {
                                callbackBlock(YES, [NSURL fileURLWithPath:savePath]);
                            }
                        }
                        else
                        {
                            NSLog(@"处理视频失败 %ld", (long)videoWriter.status);

                            if (callbackBlock)
                            {
                                callbackBlock(NO, @"");
                            }
                        }
                    });
                }];

                CVPixelBufferPoolRelease(adaptor.pixelBufferPool);

                break;
            }
        }
    }
}

+ (BOOL)appendToAdapter:(AVAssetWriterInputPixelBufferAdaptor *)adaptor
            pixelBuffer:(CVPixelBufferRef)buffer
                 atTime:(CMTime)presentTime
              withInput:(AVAssetWriterInput *)writerInput
{
    while (!writerInput.readyForMoreMediaData)
    {
        usleep(1);
    }

    return [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
}

@end

