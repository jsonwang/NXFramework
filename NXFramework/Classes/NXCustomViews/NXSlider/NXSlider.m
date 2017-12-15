//
//  NXSlider.m
//  QYDemo
//
//  Created by liuming on 2017/12/14.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXSlider.h"

@interface PLSliderEntry : NSObject

@property(nonatomic) float value;  // 滑动值

@property(nonatomic) NSTimeInterval startingTime;  // 开始滑动时间

@property(nonatomic) NSTimeInterval duration;  // 持续时间

@end

@implementation PLSliderEntry

- (NSString *)description
{
    return
    [@{ @"value" : @(self.value),
        @"startingTime" : @(self.startingTime),
        @"duration" : @(self.duration) } description];
}

@end



@interface NXSlider()
{
     BOOL continousTouch;
}

@property(strong, nonatomic) NSMutableArray *entries;
@end

@implementation NXSlider

#pragma mark -- 重写父类 trackingTouch 事件
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    continousTouch = NO;
    BOOL retVal = [super beginTrackingWithTouch:touch withEvent:event];
    
    if (retVal)
    {
        self.entries = nil;
        [self addNewEntry];
    }
    
    return retVal;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    continousTouch = YES;
    BOOL retVal = [super continueTrackingWithTouch:touch withEvent:event];
    
    if (retVal)
    {
        [self updateLastEntryDuration];
        [self addNewEntry];
    }
    
    return retVal;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateLastEntryDuration];
    
    if (continousTouch)
    {
        [self correctValueIfNeeded];
    }
}

#pragma mark - Properties
- (NSMutableArray *)entries
{
    if (!_entries)
    {
        _entries = [[NSMutableArray alloc] init];
    }
    
    return _entries;
}

#pragma mark - Private
- (void)addNewEntry
{
    PLSliderEntry *newEntry = [[PLSliderEntry alloc] init];
    newEntry.value = self.value;
    newEntry.startingTime = CACurrentMediaTime();
    [self.entries addObject:newEntry];
}

- (void)correctValueIfNeeded
{
    static const CGFloat kAcceptableLocationDelta = 12.0f;
    __block float properSliderValue = FLT_MIN;
    [self.entries enumerateObjectsWithOptions:NSEnumerationReverse
                                   usingBlock:^(PLSliderEntry *entry, NSUInteger idx, BOOL *stop) {
                                       if (entry.duration > 0.05)
                                       {
                                           CGFloat width = CGRectGetWidth(self.frame);
                                           CGFloat valueDelta = fabsf(entry.value - self.value);
                                           CGFloat sliderRange = fabsf(self.maximumValue - self.minimumValue);
                                           CGFloat locationDelta = valueDelta / sliderRange * width;
                                           if (locationDelta < kAcceptableLocationDelta)
                                           {
                                               properSliderValue = entry.value;
                                           }
                                           
                                           *stop = YES;
                                       }
                                   }];
    if (properSliderValue != FLT_MIN)
    {
        [self setValue:properSliderValue animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)updateLastEntryDuration
{
    PLSliderEntry *lastEntry = [self.entries lastObject];
    lastEntry.duration = CACurrentMediaTime() - lastEntry.startingTime;
}

#pragma mark -- 实现父类的方法
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(minimumValueImageRectForBounds:)])
    {
        [self.delegate minimumValueImageRectForBounds:bounds];
        
    }
    else
    {
        
        rect = [super minimumValueImageRectForBounds:bounds];
    }
    return rect;
}
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    
    CGRect rect = CGRectZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(maximumValueImageRectForBounds:)])
    {
        rect = [self.delegate maximumValueImageRectForBounds:bounds];
    }
    else
    {
        rect = [super maximumValueImageRectForBounds:bounds];
    }
    return rect;
    
}
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(trackRectForBounds:)])
    {
        rect = [self.delegate trackRectForBounds:bounds];

    }
    else
    {

        rect = [super trackRectForBounds:bounds];
    }
    return rect;
}
@end
