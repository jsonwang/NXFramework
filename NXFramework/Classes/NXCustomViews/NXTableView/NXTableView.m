//
//  NXTableView.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXTableView.h"
#import "NXPullLoadView.h"
#import "NXPullRefreshView.h"

@interface NXTableView ()

@end

@implementation NXTableView

- (void)dealloc {}
#pragma mark - Init Methods

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {}
#pragma mark - UIResponder Touch Event Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_endEditingWhenTouch)
    {
        [self endEditing:YES];
    }
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - UIScrollView Touch Event Methods

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if (_endEditingWhenTouch)
    {
        [self endEditing:YES];
    }
    return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}

#pragma mark - Public Methods

- (void)setRefreshEnabled:(BOOL)refreshEnabled
{
    if (_refreshEnabled != refreshEnabled)
    {
        _refreshEnabled = refreshEnabled;
        if (_refreshEnabled)
        {
            _pullRefreshView = [[NXPullRefreshView alloc]
                initWithFrame:CGRectMake(0.0f, -kNXPullRefreshViewHeight, CGRectGetWidth(self.frame),
                                         kNXPullRefreshViewHeight)];
            [self addSubview:_pullRefreshView];
        }
        else
        {
            [_pullRefreshView removeFromSuperview];
            _pullRefreshView = nil;
        }
    }
}

- (void)setLoadEnabled:(BOOL)loadEnabled
{
    if (_loadEnabled != loadEnabled)
    {
        _loadEnabled = loadEnabled;
        if (_loadEnabled)
        {
            _pullLoadView = [[NXPullLoadView alloc]
                initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), kNXPullLoadViewHeight)];
            self.tableFooterView = _pullLoadView;
        }
        else
        {
            self.tableFooterView = nil;
            _pullLoadView = nil;
        }
    }
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    CGSize frameSize = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    CGPoint contentOffset = scrollView.contentOffset;
    UIEdgeInsets contentInset = scrollView.contentInset;

    CGFloat topMargin = (contentOffset.y + contentInset.top);
    CGFloat bottomMargin = (contentOffset.y + frameSize.height - contentSize.height - contentInset.bottom);

    if (_refreshEnabled && !_refreshing)
    {
        if (topMargin < -kNXPullDownDistance)
        {
            _pullRefreshView.state = NXPullDownStatePulling;
        }
        else if (topMargin >= -kNXPullDownDistance && topMargin < 0.0)
        {
            _pullRefreshView.state = NXPullDownStateNormal;
            _pullRefreshView.pullNXale = -topMargin / kNXPullDownDistance;
        }
    }

    if (_loadEnabled && !_loading)
    {
        if (bottomMargin > kNXPullUpDistance)
        {
            _pullLoadView.state = NXPullDownStatePulling;
        }
        else if (bottomMargin <= kNXPullUpDistance && bottomMargin > 0.0 - kNXPullLoadViewHeight)
        {
            _pullLoadView.state = NXPullDownStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_refreshing || _loading)
    {
        return;
    }

    if (_pullRefreshView.state == NXPullDownStatePulling)
    {
        _refreshing = YES;
        _pullRefreshView.state = NXPullDownStateRefreshing;
        [UIView animateWithDuration:0.18f
                         animations:^{
                             UIEdgeInsets contentInset = self.contentInset;
                             contentInset.top += kNXPullRefreshViewHeight;
                             self.contentInset = contentInset;
                         }];
        if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(tableViewDidStartRefresh:)])
        {
            [_pullDelegate tableViewDidStartRefresh:self];
        }
    }

    if (_pullLoadView.state == NXPullUpStatePulling)
    {
        _loading = YES;
        _pullLoadView.state = NXPullUpStateLoading;
        if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(tableViewDidStartLoadMore:)])
        {
            [_pullDelegate tableViewDidStartLoadMore:self];
        }
    }
}

- (void)tableViewDataSourceDidFinishedRefresh
{
    if (_refreshing)
    {
        _refreshing = NO;
        _pullRefreshView.state = NXPullDownStateNormal;
        [UIView animateWithDuration:0.18f
                         animations:^{
                             UIEdgeInsets contentInset = self.contentInset;
                             contentInset.top -= kNXPullRefreshViewHeight;
                             self.contentInset = contentInset;
                         }];

        NSDate *lastUpdatedDate = nil;
        if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(tableViewRefreshFinishedDate)])
        {
            lastUpdatedDate = [_pullDelegate tableViewRefreshFinishedDate];
        }
        else
        {
            lastUpdatedDate = [NSDate date];
        }
        [_pullRefreshView refreshLastUpdatedDate:lastUpdatedDate];
    }
}

- (void)tableViewDataSourceDidFinishedLoadMore
{
    if (_loading)
    {
        _loading = NO;
        _pullLoadView.state = NXPullUpStateNormal;
    }
}

- (void)tableViewDataSourceWillStartRefresh
{
    if (_refreshing)
    {
        return;
    }

    _refreshing = YES;
    _pullRefreshView.state = NXPullDownStateRefreshing;
    [UIView animateWithDuration:0.18f
                     animations:^{
                         UIEdgeInsets contentInset = self.contentInset;
                         contentInset.top += kNXPullRefreshViewHeight;
                         self.contentInset = contentInset;
                         self.contentOffset = CGPointMake(0.0f, -contentInset.top);
                     }];
    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(tableViewDidStartRefresh:)])
    {
        [_pullDelegate tableViewDidStartRefresh:self];
    }
}

@end
