//
//  NXPullRefreshView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXCircleView.h"
#import "NXView.h"

extern const CGFloat kNXPullRefreshViewHeight;

extern const CGFloat kNXPullDownDistance;

typedef NS_ENUM(NSInteger, NXPullDownState) {
    NXPullDownStateNormal = 1,  // 正常
    NXPullDownStatePulling,     // 下拉中
    NXPullDownStateRefreshing,  // 刷新中
};

@interface NXPullRefreshView : NXView

@property(nonatomic, strong, readonly) UILabel *statusLabel;

@property(nonatomic, strong, readonly) UILabel *dateLabel;

@property(nonatomic, strong, readonly) NXCircleView *circleView;
//@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;

@property(nonatomic, assign) NXPullDownState state;
@property(nonatomic, assign) CGFloat pullNXale;

- (void)refreshLastUpdatedDate:(NSDate *)date;

@end
