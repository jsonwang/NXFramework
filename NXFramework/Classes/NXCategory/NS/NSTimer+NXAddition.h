//
//  NSTimer+NXAddition.h
//  ZhongTouBang
//
//  Created by AK on 8/20/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (NXAddition)

/**
 * 暂停
 *
 */
- (void)nx_pause;

/**
 * 继续
 *
 */
- (void)nx_resume;


/**
 * 指定时间后继续
 * @param interval 指定时间
 */
- (void)nx_resumeAfterTimeInterval:(NSTimeInterval)interval;

@end
