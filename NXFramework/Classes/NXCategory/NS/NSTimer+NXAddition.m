//
//  NSTimer+NXAddition.m
//  ZhongTouBang
//
//  Created by AK on 8/20/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NSTimer+NXAddition.h"

@implementation NSTimer (NXAddition)

- (void)nx_pause
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)nx_resume
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)nx_resumeAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid])
    {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
