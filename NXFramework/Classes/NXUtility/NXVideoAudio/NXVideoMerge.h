//
//  NXVideoRecorder.h
//  Philm
//
//  Created by AK on 2017/2/16.
//  Copyright © 2017年 yoyo. All rights reserved.
//
/**
 *  功能 :将多段视频合并成一个MP4视频
 *
 */
#import <Foundation/Foundation.h>
#import "NXConfig.h"

//合成进度
typedef void (^NXProgressHandler)(double progress);
@interface NXVideoMerge : NSObject
{
 
}

//合成进度 ,回调会回到主线
@property (nonatomic, copy) NXProgressHandler progressHandler;


/**
 *  合成多段视频
 *
 *  @param fileURLArray 包含所有视频分段的文件URL数组，必须是[NSURL fileURLWithString:...]得到的
 *  @param renderSize   输出视频的宽高
 *  @param finishBlock  生成视频结果回调 返回的是NSURL类型 并回到主线
 */
- (void)mergeAndExportVideosWithFileURLs:(NSArray<NSURL *> *)fileURLArray
                              renderSize:(CGSize)renderSize
                             finishBlock:(NXGenericCallback)finishBlock;

/**
 *  合成多段视频
 *
 *  @param fileURLArray 包含所有视频分段的文件URL数组，必须是[NSURL fileURLWithString:...]得到的
 *  @param renderSize   输出视频的宽高
 *  @param savePath     输出视频MP4的文件路径 delault is ~/Library/Caches/NXExportVideo.mp4
 *  @param finishBlock  生成视频结果回调 返回的是NSURL类型 并回到主线
 */
- (void)mergeAndExportVideosWithFileURLs:(NSArray<NSURL *> *)fileURLArray
                              renderSize:(CGSize)renderSize
                                savePath:(NSString *)savePath
                             finishBlock:(NXGenericCallback)finishBlock;
@end

