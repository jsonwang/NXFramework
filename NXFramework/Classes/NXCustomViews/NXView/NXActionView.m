//
//  NXActionView.m
//  NXlib
//
//  Created by AK on 9/19/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXActionView.h"

#import "UIView+NXCategory.h"

const static CGFloat NXActionViewAnimationDuration = 0.25;

const static CGFloat NXActionViewAnimationShowAlpha = 1.0;
const static CGFloat NXActionViewAnimationDismissAlpha = 0.0;

const static CGFloat NXActionViewMaskShowAlpha = 0.5;
const static CGFloat NXActionViewMaskDismissAlpha = 0.0;

@interface NXActionView ()

@property(nonatomic, strong) UIControl *mask;

@property(nonatomic) BOOL visible;

@end

@implementation NXActionView

#pragma mark - Init Method

- (void)initialize
{
    self.duration = NXActionViewAnimationDuration;
    self.animationOptions = UIViewAnimationOptionCurveEaseInOut;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    return self;
}

#pragma mark - Override Method

- (UIControl *)mask
{
    if (!_mask)
    {
        _mask = [[UIControl alloc] initWithFrame:CGRectZero];
        _mask.backgroundColor = [UIColor blackColor];
        _mask.alpha = NXActionViewMaskDismissAlpha;
        _mask.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [_mask addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mask;
}

#pragma mark - Action Method

- (void)cancel
{
    if (_willTapCancelHandler)
    {
        BOOL canCancel = _willTapCancelHandler();
        if (!canCancel)
        {
            return;
        }
    }

    [self dismiss];

    if (_didTapCancelHandler)
    {
        _didTapCancelHandler();
    }
}

#pragma mark - Public Method

- (void)showInView:(UIView *)view
{
    if (self.isVisible)
    {
        if (view == self.superview)
        {
            return;
        }
        else
        {
            [self dismiss];
        }
    }

    [self showInView:view beginForAction:_actionAnimations];

    [UIView animateWithDuration:_duration
                          delay:_delay
                        options:_animationOptions
                     animations:[self showInView:view animationsForAction:_actionAnimations]
                     completion:[self showInView:view completionForAction:_actionAnimations]];
}

- (void)dismiss
{
    [UIView animateWithDuration:_duration
                          delay:_delay
                        options:_animationOptions
                     animations:[self dismissAnimationsForAction:_actionAnimations]
                     completion:[self dismisNXompletionForAction:_actionAnimations]];
}

#pragma mark - Private Method

- (void)showInView:(UIView *)view beginForAction:(NXViewActionAnimations)actionAnimations
{
    UIView *containerView = [self viewForShowIn:view];
//    self.mask.size = containerView.nx_orientationSize;
    //这里是几个意思
    self.mask.center = containerView.nx_orientationMiddle;
    if (actionAnimations == NXViewActionAnimationActionSheet)
    {
//        self.top = containerView.nx_orientationHeight;
//        self.width = containerView.nx_orientationWidth;
        self.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
    }
    else if (actionAnimations == NXViewActionAnimationAlert)
    {
        self.center = containerView.nx_orientationMiddle;
        self.alpha = NXActionViewAnimationDismissAlpha;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
    }
    [containerView addSubview:self.mask];
    [containerView addSubview:self];
}

- (void (^)(void))showInView:(UIView *)view animationsForAction:(NXViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self) weakSelf = self;
    void (^animations)(void) = NULL;
    if (actionAnimations == NXViewActionAnimationActionSheet)
    {
        animations = ^(void) {
            UIView *containerView = [self viewForShowIn:view];
            weakSelf.mask.alpha = NXActionViewMaskShowAlpha;
            //这里是啥意思
//            weakSelf.top = containerView.nx_orientationHeight - weakSelf.height;
        };
    }
    else if (actionAnimations == NXViewActionAnimationAlert)
    {
        animations = ^(void) {
            weakSelf.mask.alpha = NXActionViewMaskShowAlpha;
            weakSelf.alpha = NXActionViewAnimationShowAlpha;
        };
    }
    return animations;
}

- (void (^)(void))dismissAnimationsForAction:(NXViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self) weakSelf = self;
    void (^animations)(void) = NULL;
    if (actionAnimations == NXViewActionAnimationActionSheet)
    {
        animations = ^(void) {
            UIView *containerView = self.superview;
            weakSelf.mask.alpha = NXActionViewMaskDismissAlpha;
            //这里是啥意思
//            weakSelf.top = containerView.nx_orientationHeight;
        };
    }
    else if (actionAnimations == NXViewActionAnimationAlert)
    {
        animations = ^(void) {
            weakSelf.mask.alpha = NXActionViewMaskDismissAlpha;
            weakSelf.alpha = NXActionViewAnimationDismissAlpha;
        };
    }
    return animations;
}

- (void (^)(BOOL finished))showInView:(UIView *)view completionForAction:(NXViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self) weakSelf = self;
    void (^completion)(BOOL finished) = NULL;
    if (actionAnimations == NXViewActionAnimationActionSheet)
    {
        completion = ^(BOOL finished) {
            weakSelf.visible = YES;
        };
    }
    else if (actionAnimations == NXViewActionAnimationAlert)
    {
        completion = ^(BOOL finished) {
            weakSelf.visible = YES;
        };
    }
    return completion;
}

- (void (^)(BOOL finished))dismisNXompletionForAction:(NXViewActionAnimations)actionAnimations
{
    __weak __typeof(&*self) weakSelf = self;
    void (^completion)(BOOL finished) = NULL;
    if (actionAnimations == NXViewActionAnimationActionSheet)
    {
        completion = ^(BOOL finished) {
            [weakSelf.mask removeFromSuperview];
            [weakSelf removeFromSuperview];
            weakSelf.visible = NO;
        };
    }
    else if (actionAnimations == NXViewActionAnimationAlert)
    {
        completion = ^(BOOL finished) {
            [weakSelf.mask removeFromSuperview];
            [weakSelf removeFromSuperview];
            weakSelf.visible = NO;
        };
    }
    return completion;
}

#pragma mark - Rotate Orientation

- (UIView *)viewForShowIn:(UIView *)view
{
    UIWindow *window = view.window;
    UIView *windowView = [window.subviews firstObject];
    return windowView ?: view;
}

@end
