//
//  NXPlayer.m
//  NXlib
//
//  Created by AK on 15/12/20.
//  Copyright © 2015年 AK. All rights reserved.
//

#import "NXPlayer.h"

#import "NXConfig.h"
#import "NSString+NXCategory.h"
#import "NXFileManager.h"
@interface NXPlayer ()
{
}
//初始化音频对象，player要求是全局对象 局部变量播放不出声音
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;

@property(nonatomic, strong) NXPlayerConfigHandler configHandler;

@property(nonatomic, strong) NXPlayerPlayFinishHandler finishHandler;
@property(nonatomic, strong) NXPlayerPlayFailureHandler failureHandler;

@end

@implementation NXPlayer

//单例
NXSINGLETON(NXPlayer);

- (instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

//设置 handler
- (void)setHandlerWithConfigHandler:(NXPlayerConfigHandler)config
                       finisHandler:(NXPlayerPlayFinishHandler)finish
                     failureHandler:(NXPlayerPlayFailureHandler)failure
{
    self.configHandler = config;
    self.finishHandler = finish;
    self.failureHandler = failure;

    // more...
}

- (void)clearHandlerBlock
{
    // nil out to break the retain cycle.
    self.configHandler = nil;
    self.finishHandler = nil;
    self.failureHandler = nil;
}

//检查路径是否有错误 空/文件不存在
- (NSError *)checkMusicPathErrorWithFilePath:(NSString *)filePath
{
    NSError *error = nil;
    if ([NSString nx_isBlankString:filePath])
    {
        NSLog(@"path is error !!!!");

        NSString *failureReason = @"filePath is blank";
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : failureReason};

        error = [NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:userInfo];
    }
    else if (![filePath hasPrefix:@"http"])
    {
        //本地路径
        if (![NXFileManager existsItemAtPath:filePath])
        {
            NSLog(@"file is not exists !!!!");

            NSString *failureReason = @"file is not exists";
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : failureReason};
            // NSFileReadInapplicableStringEncodingError
            //            NSURLErrorTimedOut
            error = [NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:userInfo];
        }
    }

    return error;
}

- (void)playMusicWithFilePath:(NSString *)path
                configHandler:(NXPlayerConfigHandler)config
                 finisHandler:(NXPlayerPlayFinishHandler)finish
               failureHandler:(NXPlayerPlayFailureHandler)failure
{
    [self setHandlerWithConfigHandler:config finisHandler:finish failureHandler:failure];

    NSError *err = [self checkMusicPathErrorWithFilePath:path];
    if (err)
    {
        if (self.failureHandler)
        {
            self.failureHandler(self.audioPlayer, err);
        }
        NSLog(@"文件路径错误: %@", [err localizedDescription]);
        return;
    }

    //文件路径没问题 初始化播放器
    if ([path hasPrefix:@"http"])
    {
        //网络地址
        self.audioPlayer =
            [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]] error:&err];
    }
    else
    {
        //本地地址
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    }

    if (err)
    {
        if (self.failureHandler)
        {
            self.failureHandler(self.audioPlayer, err);
        }
        NSLog(@"播放器初始化失败: %@", [err localizedDescription]);
        return;
    }

    self.audioPlayer.delegate = (id<AVAudioPlayerDelegate>)self;
    self.audioPlayer.volume = 1.0f;

    if (self.configHandler)
    {
        self.configHandler(self.audioPlayer);
    }

    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

#pragma mark - class mth
+ (void)setCurrentTime:(int)time { [[NXPlayer sharedInstance] setCurrentTime:time]; }
+ (void)play { [[NXPlayer sharedInstance] play]; }
+ (void)pause { [[NXPlayer sharedInstance] pause]; }
+ (int)currentTime { return [[NXPlayer sharedInstance] currentTime]; }
+ (int)duration { return [[NXPlayer sharedInstance] duration]; }
+ (BOOL)isPlaying { return [[NXPlayer sharedInstance] isPlaying]; }
- (BOOL)isPlaying { return self.audioPlayer.isPlaying; }
- (void)setCurrentTime:(int)time { self.audioPlayer.currentTime = time; }
- (void)play { [self.audioPlayer play]; }
- (void)pause { [self.audioPlayer pause]; }
- (int)currentTime { return self.audioPlayer.currentTime; }
- (int)duration { return self.audioPlayer.duration; }
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放结束 %@", player.url.absoluteString);
    //播放结束
    if (self.finishHandler)
    {
        self.finishHandler();
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *__nullable)error
{
    //解码错误
    NSLog(@"解码错误 %@", [error description]);

    if (self.failureHandler)
    {
        self.failureHandler(self.audioPlayer, error);
    }
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {}
@end
