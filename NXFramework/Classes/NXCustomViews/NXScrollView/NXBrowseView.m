//
//  NXBrowseView.m
//  NXlib
//
//  Created by AK on 8/5/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXBrowseView.h"

#import "NSString+NXCategory.h"
#import "NSTimer+NXAddition.h"

#import "UIView+NXCategory.h"
#import <objc/runtime.h>

/// 循环滚动时间间隔
static const CGFloat NXBrowseViewCyclePageDuration = 3.0;

typedef void (^NXBrowseViewPageWillSelectAction)(NXBrowseViewPage *page);
typedef void (^NXBrowseViewPageDidSelectAction)(NXBrowseViewPage *page);

static const void *NXBrowseViewPageWillSelectActionKey = &NXBrowseViewPageWillSelectActionKey;
static const void *NXBrowseViewPageDidSelectActionKey = &NXBrowseViewPageDidSelectActionKey;

/**
 *  NXBrowseViewPage (private)
 */
@interface NXBrowseViewPage (private)

@property(nonatomic, copy) NXBrowseViewPageWillSelectAction willSelectAction;
@property(nonatomic, copy) NXBrowseViewPageDidSelectAction didSelectAction;

@end

@implementation NXBrowseViewPage (private)

@dynamic willSelectAction;
@dynamic didSelectAction;

#pragma mark - Getter/Setter Method

- (NXBrowseViewPageWillSelectAction)willSelectAction
{
    id action = objc_getAssociatedObject(self, NXBrowseViewPageWillSelectActionKey);
    return action;
}

- (void)setWillSelectAction:(NXBrowseViewPageWillSelectAction)willSelectAction
{
    objc_setAssociatedObject(self, NXBrowseViewPageWillSelectActionKey, willSelectAction, OBJC_ASSOCIATION_COPY);
}

- (NXBrowseViewPageDidSelectAction)didSelectAction
{
    id action = objc_getAssociatedObject(self, NXBrowseViewPageDidSelectActionKey);
    return action;
}

- (void)setDidSelectAction:(NXBrowseViewPageDidSelectAction)didSelectAction
{
    objc_setAssociatedObject(self, NXBrowseViewPageDidSelectActionKey, didSelectAction, OBJC_ASSOCIATION_COPY);
}

#pragma mark - UIResponder Touch Event Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
    {
        if (self.willSelectAction)
        {
            self.willSelectAction(self);
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event { [super touchesMoved:touches withEvent:event]; }
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
    {
        if (self.didSelectAction)
        {
            self.didSelectAction(self);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

@end

/**
 *  NXBrowseView
 */
@interface NXBrowseView ()<UIScrollViewDelegate>

/// 可重用的Page
@property(nonatomic, strong) NSMutableDictionary *reusablePages;

/// 已加载的Page
@property(nonatomic, strong) NSMutableArray *loadedPages;

/// 循环滚动计时器
@property(nonatomic, strong) NSTimer *scrollingTimer;

@end

@implementation NXBrowseView

- (void)dealloc { [self stopPageing]; }
#pragma mark - Init Method

- (void)initialize
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.loadedPages = [NSMutableArray array];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        [self initialize];
    }
    return self;
}

#pragma mark - Override Method

//- (void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
//
//    [self reloadData];
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self __browsePage];

    if (_browseDelegate && [_browseDelegate respondsToSelector:@selector(browseViewDidScroll:)])
    {
        [_browseDelegate browseViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { [self.scrollingTimer nx_pause]; }
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.scrollingTimer nx_resumeAfterTimeInterval:NXBrowseViewCyclePageDuration];
}

#pragma mark - Public Method

- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    if ([NSString nx_isBlankString:identifier])
    {
        return nil;
    }
    id page = _reusablePages[identifier];
    [_reusablePages removeObjectForKey:identifier];
    return page;
}

- (void)reloadData
{
    [_loadedPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_loadedPages removeAllObjects];

    NSInteger numberOfPages = [_browseDataSource numberOfPagesInBrowseView:self];
    self.numberOfPages = numberOfPages;

    NSInteger currentPage = self.currentPage;
    [self __loadPageAtIndex:currentPage - 1];
    [self __loadPageAtIndex:currentPage];
    [self __loadPageAtIndex:currentPage + 1];
}

- (NSInteger)indexForPageAtPoint:(CGPoint)point
{
    NSInteger numberOfPages = [_browseDataSource numberOfPagesInBrowseView:self];
    NSInteger index = NSNotFound;
    for (int idx = 0; idx < numberOfPages; ++idx)
    {
        CGRect rectOfIndex = [self __rectForIndex:idx];
        if (CGRectContainsPoint(rectOfIndex, point))
        {
            index = idx;
            break;
        }
    }
    return index;
}

- (NSInteger)indexForPage:(NXBrowseViewPage *)page { return [self indexForPageAtPoint:page.center]; }
- (NXBrowseViewPage *)pageForIndex:(NSInteger)index
{
    NSInteger count = [_loadedPages count];
    for (int i = 0; i < count; ++i)
    {
        NXBrowseViewPage *itemPage = _loadedPages[i];
        NSInteger itemIndex = [self indexForPage:itemPage];
        if (itemIndex == index)
        {
            return itemPage;
        }
    }
    return nil;
}

- (void)startPageing
{
    if (self.numberOfPages <= 0)
    {
        return;
    }

    self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:NXBrowseViewCyclePageDuration
                                                           target:self
                                                         selector:@selector(__cyclePage)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)stopPageing
{
    [_scrollingTimer invalidate];
    self.scrollingTimer = nil;
}

#pragma mark - Private Method

- (void)__recyclePage:(NXBrowseViewPage *)page
{
    if (_reusablePages)
    {
        if (!_reusablePages[page.reuseIdentifier])
        {
            _reusablePages[page.reuseIdentifier] = page;
        }
    }
    else
    {
        self.reusablePages = [NSMutableDictionary dictionary];
        _reusablePages[page.reuseIdentifier] = page;
    }
}

- (void)__browsePage
{
    NSInteger currentPage = self.currentPage;
    if (![self pageForIndex:currentPage - 1])
    {
        [self __loadPageAtIndex:currentPage - 1];
    }
    if (![self pageForIndex:currentPage])
    {
        [self __loadPageAtIndex:currentPage];
    }
    if (![self pageForIndex:currentPage + 1])
    {
        [self __loadPageAtIndex:currentPage + 1];
    }

    NSMutableArray *reusablePages = [NSMutableArray array];
    for (NXBrowseViewPage *itemPage in _loadedPages)
    {
        NSInteger index = [self indexForPage:itemPage];
        if (abs((int)(index - currentPage)) > 1)
        {
            [reusablePages addObject:itemPage];
            [self __recyclePage:itemPage];
        }
    }
    [reusablePages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_loadedPages removeObjectsInArray:reusablePages];
}

- (void)__cyclePage
{
    if ([self isLastPage])
    {
        [self scrollToFirstPage];
    }
    else
    {
        [self scrollToNextPage];
    }
}

- (BOOL)__validOfIndex:(NSInteger)index
{
    NSInteger numberOfPages = [_browseDataSource numberOfPagesInBrowseView:self];
    return (0 <= index) && (index < numberOfPages);
}

- (CGRect)__rectForIndex:(NSInteger)index
{
    CGRect rectOfIndex = CGRectZero;
    if (self.pageDirection == NXScrollViewPageDirectionVertical)
    {
        rectOfIndex = CGRectMake(0.0, self.nx_height * index, self.nx_width, self.nx_height);
    }
    else
    {
        rectOfIndex = CGRectMake(self.nx_width * index, 0.0, self.nx_width, self.nx_height);
    }
    return rectOfIndex;
}

- (void)__loadPageAtIndex:(NSInteger)index
{
    if (![self __validOfIndex:index])
    {
        return;
    }

    NXBrowseViewPage *page = [_browseDataSource browseView:self pageAtIndex:index];
    page.frame = [self __rectForIndex:index];
    __weak __typeof(&*self) weakSelf = self;
    page.willSelectAction = ^(NXBrowseViewPage *page) {
        if (weakSelf.browseDelegate &&
            [weakSelf.browseDelegate respondsToSelector:@selector(browseView:willSelectPageAtIndex:)])
        {
            NSInteger index = [weakSelf indexForPage:page];
            [weakSelf.browseDelegate browseView:weakSelf willSelectPageAtIndex:index];
        }
    };
    page.didSelectAction = ^(NXBrowseViewPage *page) {
        if (weakSelf.browseDelegate &&
            [weakSelf.browseDelegate respondsToSelector:@selector(browseView:didSelectPageAtIndex:)])
        {
            NSInteger index = [weakSelf indexForPage:page];
            [weakSelf.browseDelegate browseView:weakSelf didSelectPageAtIndex:index];
        }
    };
    [self addSubview:page];

    [_loadedPages addObject:page];
}

@end
