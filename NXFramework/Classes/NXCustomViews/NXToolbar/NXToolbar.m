//
//  NXToolbar.m
//  NXlib
//
//  Created by AK on 9/23/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXToolbar.h"

#import "UIBarButtonItem+NXAddition.h"

#import "NXAdaptedSystem.h"

@implementation NXToolbar

- (instancetype)initWithFrame:(CGRect)frame actionStyle:(NXToolbarActionStyle)actionStyle
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.actionStyle = actionStyle;
    }
    return self;
}

#pragma mark - Action Method

- (void)doneAction:(__unused id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(toolbarDidDone:)])
    {
        [_actionDelegate toolbarDidDone:self];
    }
}

- (void)cancelAction:(__unused id)sender
{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(toolbarDidCancel:)])
    {
        [_actionDelegate toolbarDidCancel:self];
    }
}

#pragma mark - Public Method

- (void)setActionStyle:(NXToolbarActionStyle)actionStyle
{
    if (_actionStyle != actionStyle)
    {
        _actionStyle = actionStyle;
        [self __setActionStyle];
    }
}

#pragma mark - Private Method

- (void)__setActionStyle
{
    if (_actionStyle == NXToolbarActionStyleDoneAndCancel)
    {
        [self __setActionStyleDoneAndCancel];
    }
}

- (void)__setActionStyleDoneAndCancel
{
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithFixedSpaceWidth:10.0f];

    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTarget:self action:@selector(cancelAction:)];
    cancelBarItem.title = NSLocalizedStringFromTable(@"SCFW_LS_Cancel", @"SCFWLocalizable", nil);
    cancelBarItem.style = UIBarButtonItemStyleDone;

    UIBarButtonItem *flexibleSpaceItem = [UIBarButtonItem nx_flexibleSpaceSystemItem];

    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTarget:self action:@selector(doneAction:)];
    doneBarItem.title = NSLocalizedStringFromTable(@"SCFW_LS_Done", @"SCFWLocalizable", nil);
    doneBarItem.style = UIBarButtonItemStyleDone;

    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithFixedSpaceWidth:10.0f];

    if (NXiOS8OrLater())
    {
        self.items = @[ leftSpaceItem, cancelBarItem, flexibleSpaceItem, doneBarItem, rightSpaceItem ];
    }
    else
    {
        self.items = @[ cancelBarItem, flexibleSpaceItem, doneBarItem ];
    }
}

@end
