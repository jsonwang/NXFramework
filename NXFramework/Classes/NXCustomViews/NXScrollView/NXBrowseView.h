//
//  NXBrowseView.h
//  NXlib
//
//  Created by AK on 8/5/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXBrowseViewPage.h"
#import "NXScrollView.h"

@class NXBrowseView;

@protocol NXBrowseViewDataSource;
@protocol NXBrowseViewDelegate;

@interface NXBrowseView : NXScrollView

@property(nonatomic, weak) id<NXBrowseViewDataSource> browseDataSource;
@property(nonatomic, weak) id<NXBrowseViewDelegate> browseDelegate;

/**
 Used by the delegate to acquire an already allocated view, in lieu of allocating a new one.
 根据标识符 获取重用cell 如果没有  定义一个新的view
 @param identifier 标识符
 @return NXBrowseView
 */
- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier;

// reloads everything from scratch. redisplays visible views
- (void)reloadData;

/**
  获取指定point所在view 的index

 @param point 坐标值
 @return index
 */
- (NSInteger)indexForPageAtPoint:(CGPoint)point;

/**
 获取指定view 的index

 @param page 指定的 NXBrowseViewPage对象
 @return index
 */
- (NSInteger)indexForPage:(NXBrowseViewPage *)page;

/**
 获取 第 index 个view

 @param index 第几位
 @return NXBrowseViewPage对象
 */
- (NXBrowseViewPage *)pageForIndex:(NSInteger)index;


/**
  开始自动滚动
 */
- (void)startPageing;

/**
  停止自动滚动
 */
- (void)stopPageing;

@end

@protocol NXBrowseViewDataSource<NSObject>

@required

- (NSInteger)numberOfPagesInBrowseView:(NXBrowseView *)browseView;

- (NXBrowseViewPage *)browseView:(NXBrowseView *)browseView pageAtIndex:(NSInteger)index;

@end

@protocol NXBrowseViewDelegate<NSObject>

@optional
- (void)browseView:(NXBrowseView *)browseView willSelectPageAtIndex:(NSInteger)index;
- (void)browseView:(NXBrowseView *)browseView didSelectPageAtIndex:(NSInteger)index;
- (void)browseViewDidScroll:(NXBrowseView *)browseView;

@end
