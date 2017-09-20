//
//  NXImage2Video.h
//  OpenGLVideoMerge
//
//  Created by AK on 2017/4/17.
//  Copyright © 2017年 Tuo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    多张图片合成视频 
    e.g.
     NSArray *images = @[
         @"frame1.jpg",
         @"frame2.jpg",
         .....
     ];
     [NXImagesToVideo writeImageAsMovieWithImageNames:images size:CGSizeMake(640, 640) withCallbackBlock:^(BOOL success, id result) {
     
         if (success)
         {
             //insert your code ...
         
         }
     }];
 */
@interface NXImagesToVideo : NSObject

/**
  多张图片 合成视频

 @param array 一组图片名
 @param savePath 输出MP4 路径默认会保存到 沙盒~/Library/Caches/NXImage2Video.mp4
 @param size 视频大小
 @param fps 帧率 default is 1
 @param shouldAnimateTransitions 是否显示过渡效果 default is YES
 @param callbackBlock 处理回调 自动回到主线
 */
+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                 toPath:(NSString *)savePath
                                   size:(CGSize)size
                                    fps:(int)fps
                     animateTransitions:(BOOL)shouldAnimateTransitions
                      withCallbackBlock:(NXGenericCallback)callbackBlock;


/**
 多张图片 合成视频

 @param array 一组图片名
 @param savePath 保存路径
 @param size 视频大小
 @param callbackBlock 处理回调 自动回到主线
 */
+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                 toPath:(NSString *)savePath
                                   size:(CGSize)size
                      withCallbackBlock:(NXGenericCallback)callbackBlock;

/**
 多张图片 合成视频
 
 @param array 一组图片名
 @param size 视频大小
 @param callbackBlock 处理回调 自动回到主线
 */
+ (void)writeImageAsMovieWithImageNames:(NSArray<NSString *> *)array
                                   size:(CGSize)size
                      withCallbackBlock:(NXGenericCallback)callbackBlock;

@end

