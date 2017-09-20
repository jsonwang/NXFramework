//
//  NXCircleView.h
//  NXlib
//
//  Created by AK on 3/10/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXView.h"

@interface NXCircleView : NXView

@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, assign) CGFloat progressWidth;
@property(nonatomic, assign) CGFloat progress;  // 0~1之间的数

/**
 开始滚动
 */
- (void)startRotating;

/**
 结束滚动
 */
- (void)stopRotating;

@end

/*
@interface NXCircleView : SCView
{
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;

    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic        ) CGFloat progressWidth;
@property (nonatomic        ) CGFloat progress; //0~1之间的数

@end
*/
