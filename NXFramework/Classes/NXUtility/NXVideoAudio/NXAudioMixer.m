//
//  NXAudioMixer.m
//  NXFramework
//
//  Created by liuming on 2018/6/27.
//

#import "NXAudioMixer.h"

@interface NXAudioMixer()
@property(nonatomic,strong)NSMutableArray * audioMixParams;
@end

@implementation NXAudioMixer
- (void)startMixAudio:(NSArray<NXAudioMixerModel *> *)audioArray
              process:(doFinished)finishHandler
{
    AVMutableComposition *composition =[AVMutableComposition composition];
    self.audioMixParams =[[NSMutableArray alloc]init];
    for (NXAudioMixerModel * model in audioArray)
    {
        [self addAudioAtAsset:model.urlAsset toComposition:composition start:CMTimeMake(model.startTime * 600, 600) timeRange:model.timeRange];
    }
    [self exportAudioWithComposition:composition withMixParams:self.audioMixParams finish:finishHandler];
    
}
- (void)exportAudioWithComposition:(AVMutableComposition *)composition
                     withMixParams:(NSMutableArray *)audioMixParams
                            finish:(doFinished)finishedHandler
{
    NSAssert(composition, @"composition is nill");
    NSAssert(audioMixParams.count > 0, @"audioMixParams count <= 0");
    
    //创建一个可变的音频混合
    AVMutableAudioMix *audioMix =[AVMutableAudioMix audioMix];
    audioMix.inputParameters =[NSArray arrayWithArray:audioMixParams];//从数组里取出处理后的音频轨道参数
    
    //创建一个输出
    AVAssetExportSession *exporter =[[AVAssetExportSession alloc]
                                     initWithAsset:composition
                                     presetName:AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType = AVFileTypeAppleM4A;
    if(self.audioOutputPath.length <= 0)
    {
        NSString* fileName =[NSString stringWithFormat:@"%@.m4a",@"overMix"];
        //输出路径
        NSString *exportFile =[NSString stringWithFormat:@"%@/%@",[self getLibarayPath], fileName];
        self.audioOutputPath = exportFile;
    }
    unlink([self.audioOutputPath UTF8String]);
    NSLog(@"输出路径===%@",self.audioOutputPath);
    
    NSURL *exportURL =[NSURL fileURLWithPath:self.audioOutputPath];
    exporter.outputURL = exportURL;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            int exportStatus =(int)exporter.status;
            switch (exportStatus){
                case AVAssetExportSessionStatusCancelled:
                case AVAssetExportSessionStatusFailed:{
                    NSError *exportError = exporter.error;
                    NSLog(@"错误，信息: %@", exportError);
                    
                    break;
                }
                case AVAssetExportSessionStatusCompleted:{
                    
                    unsigned long long size = [[NSFileManager defaultManager] attributesOfItemAtPath:self.audioOutputPath error:nil].fileSize;
                    NSLog(@"是否在主线程2%d,,%llu",[NSThread isMainThread],size/1024);
                    
                    finishedHandler(exportURL);
                    break;
                }
            }
        });
    }];
}

- (BOOL)addAudioAtPath:(NSURL *)assetUlr
         toComposition:(AVMutableComposition *)composition
                 start:(CMTime)startTime
             timeRange:(CMTimeRange)timeRange
{
    AVURLAsset * urlAsset = [[AVURLAsset alloc] initWithURL:assetUlr options:nil];
    return [self addAudioAtAsset:urlAsset toComposition:composition start:startTime timeRange:timeRange];
}

- (BOOL)addAudioAtAsset:(AVURLAsset *)urlAsset
          toComposition:(AVMutableComposition *)composition
                  start:(CMTime)startTime
              timeRange:(CMTimeRange)timeRange
{
    
    AVMutableCompositionTrack *track =[composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack =[[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    NSError *error =nil;
    BOOL ok =NO;
    //AVMutableAudioMixInputParameters（输入参数可变的音频混合）
    //audioMixInputParametersWithTrack（音频混音输入参数与轨道）
    AVMutableAudioMixInputParameters *trackMix =[AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:0.1f atTime:startTime];
    //素材加入数组
    [self.audioMixParams addObject:trackMix];
    //Insert audio into track  //offsetCMTimeMake(0, 44100)
    ok = [track insertTimeRange:timeRange ofTrack:sourceAudioTrack atTime:startTime error:&error];
    return ok;
}
#pragma mark - 默认路径
-(NSString*)getLibarayPath
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    NSString *movDirectory = [path stringByAppendingPathComponent:@"tmp"];
    
    [fileManager createDirectoryAtPath:movDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return movDirectory;
}
#pragma mark -- setter / getter
- (NSMutableArray *)audioMixParams
{
    if (_audioMixParams == nil)
    {
        _audioMixParams = [[NSMutableArray alloc] init];
    }
    return _audioMixParams;
}
@end

@implementation NXAudioMixerModel

- (void)setPath:(NSString *)path
{
    _path = [path copy];
    _urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:_path] options:nil];
    _duration = CMTimeGetSeconds(_urlAsset.duration);
    _timeRange = CMTimeRangeMake(kCMTimeZero, _urlAsset.duration);
    _startTime = 0.0f;
}
@end

