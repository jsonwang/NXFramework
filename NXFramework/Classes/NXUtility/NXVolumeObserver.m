
//  Created by tashigaofei on 13/08/26.
//

NSString * const AVSystemController_SystemVolumeDidChangeNotification =
    @"AVSystemController_SystemVolumeDidChangeNotification";

#import "NXVolumeObserver.h"
@interface NXVolumeObserver ()
{
    double lastTime;
}
@end

@implementation NXVolumeObserver

+ (NXVolumeObserver *)sharedInstance;
{
    static NXVolumeObserver *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXVolumeObserver alloc] init];
    });

    return instance;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)volumeChanged:(NSNotification *)notification
{
    float volume =
        [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];

    NSString *changeReason =
        [[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];

    float tempTime = [NSDate date].timeIntervalSince1970 - lastTime;
    NSLog(@"时间间隔 %f", tempTime);
    lastTime = [NSDate date].timeIntervalSince1970;

    // 1,ExplicitVolumeChange值为真时物理键按下
    // 2,时间间隔大于1.5才算有效按下避免物理键连按操作
    if ([changeReason isEqualToString:@"ExplicitVolumeChange"] && tempTime > 1.5)
    {
        NSLog(@"音量键按下 changeReason:%@\n current volume = %f", changeReason, volume);

        if ([_delegate respondsToSelector:@selector(volumeButtonDidClick:)])
        {
            [_delegate volumeButtonDidClick:self];
        }
    }
}

- (void)startObserveVolumeChangeEvents
{
    NSLog(@"注册通知!!!!");
    [[NSNotificationCenter defaultCenter] removeObserver:AVSystemController_SystemVolumeDidChangeNotification];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:AVSystemController_SystemVolumeDidChangeNotification
                                               object:nil];
}

- (void)stopObserveVolumeChangeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:AVSystemController_SystemVolumeDidChangeNotification];
}
@end
