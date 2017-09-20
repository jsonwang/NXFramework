//
//  NXActionSheet.m
//  NXlib
//
//  Created by AK on 14/12/8.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXActionSheet.h"

@interface NXActionSheet ()<UIActionSheetDelegate>

@property(nonatomic, copy) NXActionSheetClickedHandler clickedHandler;
@property(nonatomic, copy) NXActionSheetCancelHandler cancelHandler;
@property(nonatomic, copy) NXActionSheetWillPresentHandler willPresentHandler;
@property(nonatomic, copy) NXActionSheetDidPresentHandler didPresentHandler;
@property(nonatomic, copy) NXActionSheetWillDismissHandler willDismissHandler;
@property(nonatomic, copy) NXActionSheetDidDismissHandler didDismissHandler;

@end

@implementation NXActionSheet

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickedHandler)
    {
        self.clickedHandler(actionSheet, buttonIndex);
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    if (self.cancelHandler)
    {
        self.cancelHandler(actionSheet);
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.willPresentHandler)
    {
        self.willPresentHandler(actionSheet);
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.didPresentHandler)
    {
        self.didPresentHandler(actionSheet);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.willDismissHandler)
    {
        self.willDismissHandler(actionSheet, buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.didDismissHandler)
    {
        self.didDismissHandler(actionSheet, buttonIndex);
    }
}

#pragma mark - Public Method

- (void)setClickedHandler:(NXActionSheetClickedHandler)clickedHandler
{
    self.delegate = self;

    _clickedHandler = nil;
    _clickedHandler = [clickedHandler copy];
}

- (void)setCancelHandler:(NXActionSheetCancelHandler)cancelHandler
{
    self.delegate = self;

    _cancelHandler = nil;
    _cancelHandler = [cancelHandler copy];
}

- (void)setWillPresentHandler:(NXActionSheetWillPresentHandler)willPresentHandler
{
    self.delegate = self;

    _willPresentHandler = nil;
    _willPresentHandler = [willPresentHandler copy];
}

- (void)setDidPresentHandler:(NXActionSheetDidPresentHandler)didPresentHandler
{
    self.delegate = self;

    _didPresentHandler = nil;
    _didPresentHandler = [didPresentHandler copy];
}

- (void)setWillDismissHandler:(NXActionSheetWillDismissHandler)willDismissHandler
{
    self.delegate = self;

    _willDismissHandler = nil;
    _willDismissHandler = [willDismissHandler copy];
}

- (void)setDidDismissHandler:(NXActionSheetDidDismissHandler)didDismissHandler
{
    self.delegate = self;

    _didDismissHandler = nil;
    _didDismissHandler = [didDismissHandler copy];
}

@end
