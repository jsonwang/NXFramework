//
//  NXVideoRecorder.m
//  Philm
//
//  Created by AK on 2017/2/16.
//  Copyright © 2017年 yoyo. All rights reserved.
//

//合并输出视频的文件名
#define NXExportVideoName @"NXExportVideo.mp4"

//视频叠加 http://www.theappguruz.com/blog/ios-overlap-multiple-videos

#import "NXVideoMerge.h"
#import <AVFoundation/AVFoundation.h>

#import "NXFileManager.h"

static void *ExportProcess = &ExportProcess;

@interface NXVideoMerge ()
{
    AVAssetExportSession *exporterSession;
    NSTimer *exportProgressTimer;  //监听导出的进度
}

@end

@implementation NXVideoMerge


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 在子类中实现本方法可以自定义显示layer
}

- (void)mergeAndExportVideosWithFileURLs:(NSArray<NSURL *> *)fileURLArray
                              renderSize:(CGSize)renderSize
                             finishBlock:(NXGenericCallback)finishBlock;
{
    NSLog(@"merge video org size %@",NSStringFromCGSize(renderSize));
    [self mergeAndExportVideosWithFileURLs:fileURLArray renderSize:renderSize savePath:@"" finishBlock:finishBlock];
}

- (void)mergeAndExportVideosWithFileURLs:(NSArray<NSURL *> *)fileURLArray
                              renderSize:(CGSize)renderSize
                                savePath:(NSString *)savePath
                             finishBlock:(NXGenericCallback)finishBlock
{
    NSLog(@"合成视频个数:  %zd", fileURLArray.count);
 
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

    CMTime totalDuration = kCMTimeZero;

    for (int i = 0; i < [fileURLArray count]; i++)
    {
        // 1 准备 asset & AssetTrack
        NSURL *videoURL = [fileURLArray objectAtIndex:i];
        AVAsset *asset = [AVAsset assetWithURL:videoURL];

        if (!asset)
        {
            NSLog(@"视频文件 %@ 读取失败", [videoURL absoluteString]);
            continue;
        }

        NSLog(@"视频idx %d path:%@ duration: %f timescale%d", i, videoURL.absoluteString,
              CMTimeGetSeconds(asset.duration), asset.duration.timescale);

        //如果视频没有视频数据不处理本视频,视频轨道总数
        NSArray *assetVideoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        //音频轨道总数
        NSArray *assetAudioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];

        if (assetVideoTracks.count == 0)
        {
            NSLog(@"此视频没有视频轨信息!!!!!");
            continue;
        }

        NSLog(@"声音轨道数: %lu", (unsigned long)assetAudioTracks.count);

        AVAssetTrack *videoAssetTrack = [assetVideoTracks objectAtIndex:0];

        //加载指定声音文件 test
        /*
         NSString *auidoPath1 = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
         AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:auidoPath1]];
         AVAssetTrack *audioAssetTrack = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];

         */

        // 2,合并音频数据 ,如果有声音数据才进行声音的合并,否则会CRASH
        if (assetAudioTracks.count > 0)
        {
            // audio track
            NSError *error = nil;

            AVMutableCompositionTrack *audioTrack =
                [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                            preferredTrackID:kCMPersistentTrackID_Invalid];

            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[assetAudioTracks objectAtIndex:0]
                                 atTime:totalDuration
                                  error:&error];
            if (error)
            {
                NSLog(@"插入声音数据失败! %@", error);
            }
        }
        else
        {
            NSLog(@"没有声音数据 %@", asset);
        }

        AVMutableCompositionTrack *videoTrack =
            [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                        preferredTrackID:kCMPersistentTrackID_Invalid];

        // 3,合并视频数据 video track
        if (assetVideoTracks.count > 0)
        {
            NSError *error = nil;

            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:videoAssetTrack
                                 atTime:totalDuration
                                  error:&error];

            if (error)
            {
                NSLog(@"videoTrack insertTime error: %@", error);
            }
        }
        else
        {
            NSLog(@"没有视频数据 %@", asset);
        }

        // fix orientationissue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton =
            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        // set other layerTransform? 如多屏指定大小显示
        /*
         CGAffineTransform SecondScale = CGAffineTransformMakeScale(0.5f,0.5f);
         CGAffineTransform SecondMove = CGAffineTransformMakeTranslation(0,0);
         [layerInstruciton setTransform:CGAffineTransformConcat(SecondScale,SecondMove) atTime:kCMTimeZero];
         */

        // XXXX 全屏合成有问题先不进行Transform
        CGAffineTransform layerTransform = [self applayAfftransform:videoAssetTrack renderSize:renderSize isCut:YES];

        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];

        [layerInstruciton setOpacity:0.0 atTime:totalDuration];

        // data
        [layerInstructionArray addObject:layerInstruciton];
    }

    // LayerInstruction's count is 0
    if (layerInstructionArray.count == 0)
    {
        if (finishBlock)
        {
            finishBlock(NO, @"视频数据都为空!!!");
        }
        return;
    }

    //导出视频
    [self exportVideoWithsavePath:savePath
                        timeRange:CMTimeRangeMake(kCMTimeZero, totalDuration)
                layerInstructions:layerInstructionArray
                       renderSize:renderSize
                   mixComposition:mixComposition
                      finishBlock:finishBlock];
}

- (void)exportVideoWithsavePath:(NSString *)savePath
                      timeRange:(CMTimeRange)timeRange
              layerInstructions:(NSArray<AVVideoCompositionLayerInstruction *> *)layerInstructions
                     renderSize:(CGSize)renderSize
                 mixComposition:(AVMutableComposition *)mixComposition
                    finishBlock:(NXGenericCallback)finishBlock

{
    //设置输出文件路径
    savePath =
        savePath.length > 0 ? savePath : [[NXFileManager getCacheDir] stringByAppendingPathComponent:NXExportVideoName];
    //如果文件存在 删除老数据
    unlink([savePath UTF8String]);

    AVMutableVideoCompositionInstruction *mainInstruciton =
        [AVMutableVideoCompositionInstruction videoCompositionInstruction];

    mainInstruciton.timeRange = timeRange;
    mainInstruciton.layerInstructions = layerInstructions;

    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[ mainInstruciton ];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = renderSize;

    [self applyVideoEffectsToComposition:mainCompositionInst size:renderSize];

    exporterSession =
        [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporterSession.videoComposition = mainCompositionInst;
    exporterSession.outputURL = [NSURL fileURLWithPath:savePath];
    exporterSession.outputFileType = AVFileTypeMPEG4;

    exporterSession.shouldOptimizeForNetworkUse = YES;
    NSLog(@"支持的文件格式 %@", [exporterSession supportedFileTypes]);

    exportProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 / 60.
                                                           target:self
                                                         selector:@selector(updateExportDisplay)
                                                         userInfo:nil
                                                          repeats:YES];

    [exporterSession exportAsynchronouslyWithCompletionHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{

            AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:savePath]];
            NSLog(@"导出视频结果 %ld 路径: %@ 时长 %f", (long)exporterSession.status, savePath,
                  CMTimeGetSeconds(asset.duration));
            //导出完成且时长不为0
            if (exporterSession.status == AVAssetExportSessionStatusCompleted && CMTimeGetSeconds(asset.duration) != 0)
            {
                if (finishBlock)
                {
                    finishBlock(YES, [NSURL fileURLWithPath:savePath]);
                }
            }
            else
            {
                NSLog(@"处理视频失败 %ld", (long)exporterSession.status);
                //合成视频失败时不在发进度block
                [exportProgressTimer invalidate];

                if (finishBlock)
                {
                    finishBlock(NO, @"");
                }
            }
        });

    }];
}

//处理进度
- (void)updateExportDisplay
{
    NSLog(@"导出进度 progress %f", exporterSession.progress);
    if (exporterSession.progress < 1)
    {
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{

            if (_progressHandler)
            {
                _progressHandler(exporterSession.progress);
                _progressHandler = nil;
            }
        });
    }
    else
    {
        [exportProgressTimer invalidate];
    }
}

- (CGAffineTransform)applayAfftransform:(AVAssetTrack *)videoAssetTrack renderSize:(CGSize)renderSize isCut:(BOOL)cut
{
    CGAffineTransform layerTransform = CGAffineTransformIdentity;
    double rate = 1.0f;
    CGPoint point = CGPointZero;

    [self computeRate:&rate targetPoint:&point renderSize:renderSize vidoSize:videoAssetTrack.naturalSize cut:cut];

    layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b,
                                           videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d,
                                           videoAssetTrack.preferredTransform.tx * rate,
                                           videoAssetTrack.preferredTransform.ty * rate);
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);  //放缩，解决前后摄像结果大小不对称
    layerTransform =
        CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, -point.x * rate, -point.y * rate));
    return layerTransform;
}
- (void)computeRate:(double *)rate
        targetPoint:(CGPoint *)point
         renderSize:(CGSize)renderSize
           vidoSize:(CGSize)videoSize
                cut:(BOOL)cut
{
    if (cut)
    {
        //按短边充满画布
        if (videoSize.width >= videoSize.height)
        {
            *rate = renderSize.height / videoSize.height;
            //视频实际宽度比画布要宽
            if (renderSize.width < *rate * videoSize.width)
            {
                (*point).x = (videoSize.width - videoSize.height) / 2.0f;
            }
        }
        else
        {
            *rate = renderSize.width / videoSize.width;
            //视频实际高度比画布要高
            if (renderSize.height < *rate * videoSize.height)
            {
                (*point).y = (videoSize.height - videoSize.width) / 2.0f;
            }
        }
    }
    else
    {
        //不足部分留黑边
        if (videoSize.width >= videoSize.height)
        {
            *rate = renderSize.width / videoSize.width;

            if (renderSize.height > *rate * videoSize.height)
            {
                (*point).y = (videoSize.height - videoSize.width) / 2.0f;
            }
        }
        else
        {
            *rate = renderSize.height / videoSize.height;

            if (renderSize.width > *rate * videoSize.width)
            {
                (*point).x = (videoSize.width - videoSize.height) / 2.0f;
            }
        }
    }
}
@end

