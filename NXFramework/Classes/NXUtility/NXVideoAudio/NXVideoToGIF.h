//
//  NXVideoToGIF.h
//  Philm
//
//  Created by AK on 2017/5/12.
//  Copyright © 2017年 yoyo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#import <WebKit/WebKit.h>
#endif


@interface NXVideoToGIF : NSObject

//通用 callback
typedef void(^NXGenericCallback)(BOOL success, id result);


+ (void)transformGIFWithURL:(NSURL*)videoURL loopCount:(int)loopCount completion:(NXGenericCallback)finishBlock;

@end
