//
//  NXLabel.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXLabel.h"
#import "NSString+NXCategory.h"

@implementation NXLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method

- (void)setText:(NSString *)text adjustWidth:(BOOL)adjustWidth
{
    if (adjustWidth)
    {
        //这里
//        CGFloat width = [text nx_widthWithFont:self.font constrainedToHeight:self.height];
//        self.width = width;
        self.text = text;
    }
    else
    {
        self.text = text;
    }
}

- (void)setText:(NSString *)text adjustHeight:(BOOL)adjustHeight
{
    if (adjustHeight)
    {
        //这里
//        CGFloat height = [text nx_heightWithFont:self.font constrainedToWidth:self.width];
//        self.height = height;
        self.text = text;
    }
    else
    {
        self.text = text;
    }
}

@end
