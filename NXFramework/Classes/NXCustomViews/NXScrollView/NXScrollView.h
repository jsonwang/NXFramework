//
//  NXScrollView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Page方向
 */
typedef NS_ENUM(NSUInteger, NXScrollViewPageDirection) {
    /**
     *  水平
     */
    NXScrollViewPageDirectionHorizontal,
    /**
     *  垂直
     */
    NXScrollViewPageDirectionVertical,
};

@protocol NXScrollViewTouchDelegate;

@interface NXScrollView : UIScrollView

@property(nonatomic, weak) id<NXScrollViewTouchDelegate> touchDelegate;

@property(nonatomic, assign) BOOL endEditingWhenTouch;

@property(nonatomic, assign) NSInteger numberOfPages;

@property(nonatomic, assign) NXScrollViewPageDirection pageDirection;


/**

 @return 当前是第几页
 */
- (NSInteger)currentPage;

/**

 @return 是否是第一页 YES 是
 */
- (BOOL)isFirstPage;


/**

 @return 是否是最后一页 YES 是
 */
- (BOOL)isLastPage;

/**
 滚动到上一页
 */
- (void)scrollToPreviousPage;

/**
滚动到下一页

 */
- (void)scrollToNextPage;

/**
  滚动到第一页
 */
- (void)scrollToFirstPage;

/**
 滚动到最后一页
 */
- (void)scrollToLastPage;

@end

@protocol NXScrollViewTouchDelegate<NSObject>

@optional
- (void)scrollView:(NXScrollView *)scrollView touchEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)scrollView:(NXScrollView *)scrollView
  touchShouldBegin:(NSSet *)touches
         withEvent:(UIEvent *)event
     inContentView:(id)view;

@end
