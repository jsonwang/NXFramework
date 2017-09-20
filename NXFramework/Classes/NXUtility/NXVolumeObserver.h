//
//  NXVolumeObserver.h
//  NXlib
//
//  Created by AK on 14/10/31.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXVolumeObserver;

@protocol NXVolumeObserverDelegate<NSObject>

- (void)volumeButtonDidClick:(NXVolumeObserver *)button;

@end

@interface NXVolumeObserver : NSObject
{
}

@property(nonatomic, strong) id<NXVolumeObserverDelegate> delegate;

+ (NXVolumeObserver *)sharedInstance;

/**
 开始声音监听
 */
- (void)startObserveVolumeChangeEvents;

/**
 结束声音监听
 */
- (void)stopObserveVolumeChangeEvents;

@end
