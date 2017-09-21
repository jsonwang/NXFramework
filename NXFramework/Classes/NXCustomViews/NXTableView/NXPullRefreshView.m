//
//  NXPullRefreshView.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXPullRefreshView.h"
#import "NSDate+NXCategory.h"
#import "NXUIDevice-Hardware.h"
#import "NSUserDefaults+NXCategory.h"

const CGFloat kNXPullRefreshViewHeight = 60.f;

const CGFloat kNXPullDownDistance = 60.f;

static NSString *const kNXUpdatedDateFormatterMMddHHmm = @"MM-dd HH:mm";
static NSString *const kNXUpdatedDateFormatterHHmm = @"HH:mm";

static NSString *const kNXLastUpdatedDateKey = @"NXLastUpdatedDateKey";

@interface NXPullRefreshView ()

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NXPullRefreshView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        CGFloat thisWidth = CGRectGetWidth(frame);
        CGFloat thisHeight = CGRectGetHeight(frame);

        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, thisHeight - 50.0f, thisWidth, 20.0f)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _statusLabel.textColor = [UIColor darkGrayColor];
        _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];

        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, thisHeight - 30.0f, thisWidth, 20.0f)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.textColor = [UIColor darkGrayColor];
        _dateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _dateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];

        _circleView = [[NXCircleView alloc] initWithFrame:CGRectMake(35.0f, thisHeight - 45.0f, 30.0f, 30.0f)];
        [self addSubview:_circleView];
        /*
        _activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:
                         UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(40.0f,
                                         thisHeight - 40.0f,
                                         20.0f,
                                         20.0f);
        _activityView.backgroundColor = [UIColor clearColor];
        _activityView.color = _circleView.progresNXolor;
        [self addSubview:_activityView];
        */
        [self setState:NXPullDownStateNormal];

        NSDate *updatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:kNXLastUpdatedDateKey];
        [self refreshLastUpdatedDate:updatedDate];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setState:(NXPullDownState)state
{
    if (_state != state)
    {
        NSString *statusText = nil;
        switch (state)
        {
            case NXPullDownStatePulling:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Release to refresh", @"NXFWLocalizable", nil);
                _circleView.progress = 1.0;
                break;
            case NXPullDownStateNormal:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Pull down to refresh", @"NXFWLocalizable", nil);
                //[_activityView stopAnimating];
                //_circleView.hidden = NO;
                [_circleView stopRotating];
                break;
            case NXPullDownStateRefreshing:
                statusText = NSLocalizedStringFromTable(@"NXFW_LS_Refreshing", @"NXFWLocalizable", nil);
                //[_activityView startAnimating];
                //_circleView.hidden = YES;
                //_circleView.progress = 0.0;
                [_circleView startRotating];
                _circleView.progress = 0.75;
                break;
            default:
                break;
        }
        _statusLabel.text = statusText;

        _state = state;
    }
}

- (void)setPullNXale:(CGFloat)pullNXale
{
    if (_pullNXale != pullNXale)
    {
        _pullNXale = pullNXale;
        _circleView.progress = pullNXale;
    }
}

- (void)refreshLastUpdatedDate:(NSDate *)date
{
    NSDate *lastUpdatedDate = date;
    if (!lastUpdatedDate)
    {
        lastUpdatedDate = [NSDate date];
    }

    NSInteger days = [lastUpdatedDate nx_daysSinceDate:[NSDate date]];
    NSString *dateFormat = nil;
    if (days == 0)
    {
        NSString *today = NSLocalizedStringFromTable(@"NXFW_LS_Last updated today", @"NXFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", today, kNXUpdatedDateFormatterHHmm];
    }
    else if (days == 1)
    {
        NSString *yesterday = NSLocalizedStringFromTable(@"NXFW_LS_Last updated yesterday", @"NXFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", yesterday, kNXUpdatedDateFormatterHHmm];
    }
    else if (days == 2)
    {
        NSString *before =
            NSLocalizedStringFromTable(@"NXFW_LS_Last updated before yesterday", @"NXFWLocalizable", nil);
        dateFormat = [NSString stringWithFormat:@"%@ %@", before, kNXUpdatedDateFormatterHHmm];
    }
    else
    {
        dateFormat = kNXUpdatedDateFormatterMMddHHmm;
    }
    NSString *dateString = [lastUpdatedDate nx_stringWithFormat:dateFormat];

    NSString *updated = NSLocalizedStringFromTable(@"NXFW_LS_Last updated time", @"NXFWLocalizable", nil);
    _dateLabel.text = [NSString stringWithFormat:@"%@ : %@", updated, dateString];

    [[NSUserDefaults standardUserDefaults] nx_saveObject:lastUpdatedDate forKey:kNXLastUpdatedDateKey];
}

@end
