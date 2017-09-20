//
//  UIBarButtonItem+NXAddition.m
//  NXlib
//
//  Created by AK on 9/23/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "UIBarButtonItem+NXAddition.h"

@implementation UIBarButtonItem (NXAddition)

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [self initWithTitle:nil style:UIBarButtonItemStylePlain target:target action:action];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
{
    self = [self initWithBarButtonSystemItem:systemItem target:nil action:nil];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFixedSpaceWidth:(CGFloat)spaceWidth
{
    self = [self initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace];
    if (self)
    {
        // Initialization code
        self.width = spaceWidth;
    }
    return self;
}

+ (instancetype)nx_flexibleSpaceSystemItem
{
    return [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace];
}

@end
