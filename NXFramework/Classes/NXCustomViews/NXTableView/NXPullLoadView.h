//
//  NXPullLoadView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXView.h"

extern const CGFloat kNXPullLoadViewHeight;

extern const CGFloat kNXPullUpDistance;

typedef NS_ENUM(NSInteger, NXPullUpState) {
    NXPullUpStateNormal = 1,  // 正常
    NXPullUpStatePulling,     // 上拉中
    NXPullUpStateLoading,     // 加载中
};

@interface NXPullLoadView : NXView

@property(nonatomic, strong, readonly) UILabel *statusLabel;

@property(nonatomic, strong, readonly) UIActivityIndicatorView *activityView;

@property(nonatomic, assign) NXPullUpState state;

@end
