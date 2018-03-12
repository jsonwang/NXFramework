//
//  NXPlayer.h
//  NXlib
//
//  Created by AK on 15/12/20.
//  Copyright © 2015年 AK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

/*
    功能:播放音频文件, 1,支持网络(http)和本地. 2默认支持播放一次.3,
   默认静音模式下不播放
    e.g.

     NSString *musicPath =
     [[NXFileManager getMainBundleRes]
   stringByAppendingPathComponent:@"shake_sound_male.wav"];

     ///var/containers/Bundle/Application/A07D8619-BD9A-4E56-9F4D-476943DD7C42/Philm.app/shake_sound_male.wav
     //    musicPath =
   @"http://cdn.y.baidu.com/dcff78b86d64b818abae1acf3d84453d.mp3";

     [[NXPlayer sharedInstance] playMusicWithFilePath:musicPath
   configHandler:^(AVAudioPlayer *player) {
        //设置无限循环
        player.numberOfLoops = -1;
     } finisHandler:^{
        //播放完成

     } failureHandler:^(AVAudioPlayer *player, NSError *failure) {

        //播放失败
     }];
 */

typedef void (^NXPlayerPlayFinishHandler)(void);
typedef void (^NXPlayerConfigHandler)(AVAudioPlayer *player);
typedef void (^NXPlayerPlayFailureHandler)(AVAudioPlayer *player, NSError *failure);

@interface NXPlayer : NSObject

+ (NXPlayer *)sharedInstance;

/**
  播放音频文件

 @param path 音频文件地址可以是本地URL(要是全路径) 和网络URL(要以http开头)
 @param config ConfigHandler
 @param finish 播放完成
 @param failure 播放失败
 */
- (void)playMusicWithFilePath:(NSString *)path
                configHandler:(NXPlayerConfigHandler)config
                 finisHandler:(NXPlayerPlayFinishHandler)finish
               failureHandler:(NXPlayerPlayFailureHandler)failure;

/**
 @abstract 快进音乐
 @discussion 手动设置音乐播放进度
 @param time 单位 sec
 */
+ (void)setCurrentTime:(int)time;

/**
 @abstract 播放音乐
 */
+ (void)play;

/**
 @abstract 暂停音乐
 */
+ (void)pause;

/**
 @abstract 取得音乐当前播放进度
 @returns 单位 sec
 */
+ (int)currentTime;

/**
 @abstract 取得音乐剩余进度
 @returns 单位 sec
 */
+ (int)duration;

/**
 @abstract 取得音乐是否正在播放
 @returns YES 为正在播放中
 */
+ (BOOL)isPlaying;

@end
