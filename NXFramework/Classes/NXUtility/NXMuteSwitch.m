//
//  NXMuteSwitch.m
//  Philm
//
//  Created by AK on 16/9/9.
//  Copyright © 2016年 yoyo. All rights reserved.
//

#import "NXMuteSwitch.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSBundle+NXCategory.h"
#import "NXConfig.h"
/**
 Sound completion proc - this is the real magic, we simply calculate how long it
 took for the sound to finish playing
 In silent mode, playback will end very fast (but not in zero time)
 */
void SharkfoodSoundMuteNotificationCompletionProc(SystemSoundID ssID, void *clientData);

@interface NXMuteSwitch ()
/**
 Find out how fast the completion call is called
 */
@property(nonatomic, assign) NSTimeInterval interval;
/**
 Our silent sound (0.5 sec)
 */
@property(nonatomic, assign) SystemSoundID soundId;
/**
 Set to true after the block was set or during init.
 Otherwise the block is called only when the switch value actually changes
 */
@property(nonatomic, assign) BOOL forceEmit;
/**
 Sound completion, objc
 */
- (void)complete;
/**
 Our loop, checks sound switch
 */
- (void)loopCheck;
/**
 Pause while in the background, if your app supports playing audio in the
 background, you want this.
 Otherwise your app will be rejected.
 */
- (void)didEnterBackground;
/**
 Resume when entering foreground
 */
- (void)willReturnToForeground;
/**
 Schedule a next check
 */
- (void)scheduleCall;
/**
 Is paused?
 */
@property(nonatomic, assign) BOOL isPaused;
/**
 Currently playing? used when returning from the background (if went to
 background and foreground really quickly)
 */
@property(nonatomic, assign) BOOL isPlaying;

@end

void SharkfoodSoundMuteNotificationCompletionProc(SystemSoundID ssID, void *clientData)
{
    NXMuteSwitch *detecotr = (__bridge NXMuteSwitch *)clientData;
    [detecotr complete];
}
@implementation NXMuteSwitch

NXSINGLETON(NXMuteSwitch);
- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willReturnToForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}
- (void)detectMuteSwitch
{
    if (!self.isPlaying)
    {
        NSString * path = [NSBundle nx_pathForResource:@"mute" ofType:@"caf"];
        NSURL *urlPath = [NSURL fileURLWithPath:path];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(urlPath), &_soundId) == kAudioServicesNoError)
        {
            AudioServicesAddSystemSoundCompletion(self.soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode,
                                                  SharkfoodSoundMuteNotificationCompletionProc,
                                                  (__bridge void *)(self));
            UInt32 yes = 1;
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(_soundId), &_soundId, sizeof(yes), &yes);
            //            [self performSelector:@selector(loopCheck) withObject:nil
            //            afterDelay:0.2];
            [self loopCheck];

            self.forceEmit = YES;
        }
        else
        {
            self.soundId = -1;
        }
    }
}
- (void)didEnterBackground { self.isPaused = YES; }
- (void)willReturnToForeground
{
    self.isPaused = NO;
    if (!self.isPlaying)
    {
        [self scheduleCall];
    }
}

- (void)setSilentNotify:(SharkfoodMuteSwitchDetectorBlock)silentNotify
{
    _silentNotify = [silentNotify copy];
    self.forceEmit = YES;
}

- (void)scheduleCall
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopCheck) object:nil];
    [self performSelector:@selector(loopCheck) withObject:nil afterDelay:1.0f];
}

- (void)complete
{
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - self.interval;
    BOOL isMute = elapsed < 0.1;  // Should have been 0.5 sec, but it seems to
                                  // return much faster (0.3something)
    NSLog(@"音频播放时间 --%f", elapsed);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        if (isMute || self.forceEmit)
        {
            self.forceEmit = NO;
            _isMute = isMute;
            if (self.silentNotify)
            {
                self.silentNotify(isMute);
            }
        }
    }
    self.isPlaying = NO;
}

- (void)loopCheck
{
    if (!self.isPaused && !self.isPlaying)
    {
        self.interval = [NSDate timeIntervalSinceReferenceDate];
        self.isPlaying = YES;
        AudioServicesPlaySystemSound(self.soundId);
    }
}

// For reference only, this DTOR will never be invoked.

- (void)dealloc
{
    if (self.soundId != -1)
    {
        AudioServicesRemoveSystemSoundCompletion(self.soundId);
        AudioServicesDisposeSystemSoundID(self.soundId);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
