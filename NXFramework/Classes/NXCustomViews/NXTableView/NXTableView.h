//
//  NXTableView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXPullRefreshView;
@class NXPullLoadView;

@protocol NXTableViewPullDelegate;

@interface NXTableView : UITableView

@property(nonatomic, weak) id<NXTableViewPullDelegate> pullDelegate;

@property(nonatomic, strong, readonly) NXPullRefreshView *pullRefreshView;
@property(nonatomic, strong, readonly) NXPullLoadView *pullLoadView;

@property(nonatomic, assign, getter=isRefreshEnabled) BOOL refreshEnabled;
@property(nonatomic, assign, getter=isLoadEnabled) BOOL loadEnabled;

@property(nonatomic, assign, readonly, getter=isRefreshing) BOOL refreshing;
@property(nonatomic, assign, readonly, getter=isLoading) BOOL loading;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDataSourceDidFinishedRefresh;
- (void)tableViewDataSourceDidFinishedLoadMore;

- (void)tableViewDataSourceWillStartRefresh;

@property(nonatomic, assign) BOOL endEditingWhenTouch;

@end

@protocol NXTableViewPullDelegate<NSObject>

@optional
- (void)tableViewDidStartRefresh:(NXTableView *)tableView;
- (NSDate *)tableViewRefreshFinishedDate;

- (void)tableViewDidStartLoadMore:(NXTableView *)tableView;

@end
