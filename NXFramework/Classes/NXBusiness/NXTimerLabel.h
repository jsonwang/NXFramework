//
//  NXTimerLabel.h
//  Philm
//
//  Created by yoyo on 2017/9/19.
//  Copyright © 2017年 yoyo. All rights reserved.
//

//收录 MZTimerLabel 源码地址  https://github.com/mineschan/MZTimerLabel

#import <UIKit/UIKit.h>

typedef enum { NXTimerLabelTypeStopWatch, NXTimerLabelTypeTimer } NXTimerLabelType;

@class NXTimerLabel;
@protocol NXTimerLabelDelegate<NSObject>
@optional
- (void)timerLabel:(NXTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
- (void)timerLabel:(NXTimerLabel *)timerLabel countingTo:(NSTimeInterval)time timertype:(NXTimerLabelType)timerType;
- (NSString *)timerLabel:(NXTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time;
@end

@interface NXTimerLabel : UILabel

/*Delegate for finish of countdown timer */
@property(nonatomic, weak) id<NXTimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property(nonatomic, copy) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property(nonatomic, strong) UILabel *timeLabel;

/*Type to choose from stopwatch or timer*/
@property(assign) NXTimerLabelType timerType;

/*Is The Timer Running?*/
@property(assign, readonly) BOOL counting;

/*Do you want to reset the Timer after countdown?*/
@property(assign) BOOL resetTimerAfterFinish;

/*Do you want the timer to count beyond the HH limit from 0-23 e.g. 25:23:12
 * (HH:mm:ss) */
@property(assign, nonatomic) BOOL shouldCountBeyondHHLimit;

#if NS_BLOCKS_AVAILABLE
@property(copy) void (^endedBlock)(NSTimeInterval);
#endif

/*--------Init methods to choose*/
- (id)initWithTimerType:(NXTimerLabelType)theType;
- (id)initWithLabel:(UILabel *)theLabel andTimerType:(NXTimerLabelType)theType;
- (id)initWithLabel:(UILabel *)theLabel;

/*--------Timer control methods to use*/
- (void)start;
#if NS_BLOCKS_AVAILABLE
- (void)startWithEndingBlock:(void (^)(NSTimeInterval countTime))end;  // use it if you are not going to use delegate
#endif
- (void)pause;
- (void)reset;

/*--------Setter methods*/
- (void)setCountDownTime:(NSTimeInterval)time;
- (void)setStopWatchTime:(NSTimeInterval)time;
- (void)setCountDownToDate:(NSDate *)date;

- (void)addTimeCountedByTime:(NSTimeInterval)timeToAdd;

/*--------Getter methods*/
- (NSTimeInterval)getTimeCounted;
- (NSTimeInterval)getTimeRemaining;

@end
