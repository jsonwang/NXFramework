//
//  NXPullLoadView.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXPullLoadView.h"
#import "NXUIDevice-Hardware.h"

const CGFloat kNXPullLoadViewHeight = 40.f;

const CGFloat kNXPullUpDistance = 0.f;

@implementation NXPullLoadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        CGFloat thisWidth = CGRectGetWidth(frame);

        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, thisWidth, 20.0f)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];

        _activityView =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.backgroundColor = [UIColor clearColor];
        _activityView.frame = CGRectMake(40.0f, 10.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];

        [self setState:NXPullUpStateNormal];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setState:(NXPullUpState)state
{
    if (_state != state)
    {
        NSString *statusText = nil;
        switch (state)
        {
            case NXPullUpStatePulling:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Release to load", @"NXFWLocalizable", nil);
                break;
            case NXPullUpStateNormal:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Pull up to load", @"NXFWLocalizable", nil);
                [_activityView stopAnimating];
                break;
            case NXPullUpStateLoading:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Loading", @"NXFWLocalizable", nil);
                [_activityView startAnimating];
                break;
            default:
                break;
        }
        _statusLabel.text = statusText;

        _state = state;
    }
}

@end
