//
//  NXAudioMixer.h
//  NXFramework
//
//  Created by liuming on 2018/6/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class NXAudioMixerModel;
typedef void(^doFinished)(NSURL *path);
/* e.g 将 path2 和 path3 混音到 path1中
NSString * path1 = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp3"];
NSString * path2 = [[NSBundle mainBundle] pathForResource:@"boom" ofType:@"mp3"];
NSString * path3 = [[NSBundle mainBundle] pathForResource:@"eatup" ofType:@"mp3"];
NSMutableArray * audioArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < 8; i ++)
{
    if (i == 7)
    {
        NXAudioMixerModel * model = [[NXAudioMixerModel alloc] init];
        model.path = path1;
        [audioArray addObject:model];
    }
    else
    {
        NXAudioMixerModel * model = [[NXAudioMixerModel alloc] init];
        model.path = i % 2==0?path2:path3;
        model.startTime = i;
        [audioArray addObject:model];
    }
}
PLAudioMixer * mixer = [[PLAudioMixer alloc] init];
[mixer startMixAudio:audioArray process:^(NSURL *path) {
    
    self.filePath = [path path];
}];
*/

@interface NXAudioMixer : NSObject

/**
 混音后输出文件的路径
 */
@property(nonatomic,copy) NSString * audioOutputPath;

- (void)startMixAudio:(NSArray<NXAudioMixerModel *> *)audioArray
process:(doFinished)finishHandler;
@end

@interface NXAudioMixerModel :NSObject

/**
 文件path
 */
@property(nonatomic,copy)NSString * path;

/**
 根据文件path生成的 urlAsset
 */
@property(nonatomic,strong,readonly)AVURLAsset * urlAsset;

/**
 当前音频文件时长
 */
@property(nonatomic,assign,readonly)double duration;

/**
 插入混音文件的开始时间
 */
@property(nonatomic,assign)double startTime;

/**
 当前音频文件用于混合的音频时间段 //默认全部进行混音处理
 */
@property(nonatomic,assign)CMTimeRange timeRange;

@end
