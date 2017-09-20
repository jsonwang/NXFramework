//
//  NXLineLabel.m
//  NXLib
//
//  Created by AK on 14-3-7.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXLineLabel.h"

@implementation NXLineLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

- (void)dealloc
{
    self.lineColor = nil;
    //    [super dealloc];
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];

    CGSize textSize;

    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        textSize = [[self text] sizeWithAttributes:@{NSFontAttributeName : [self font]}];
    }
    else
    {
        //        textSize = [[self text] sizeWithFont:[self font]];
    }

    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y = 0.0;

    if ([self textAlignment] == NSTextAlignmentRight)
    {
        origin_x = rect.size.width - strikeWidth;
    }
    else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        origin_x = (rect.size.width - strikeWidth) / 2;
    }
    else
    {
        origin_x = 0;
    }

    switch (self.lineType)
    {
        case LineTypeUp:
        {
            origin_y = 2;
        }
        break;
        case LineTypeMiddle:
        {
            origin_y = rect.size.height / 2;
        }
        break;
        case LineTypeDown:
        {
            origin_y = rect.size.height - 2;
        }
        break;

        default:
            break;
    }

    lineRect = CGRectMake(origin_x, origin_y, strikeWidth, 1);

    if (self.lineType != LineTypeNone)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        size_t numComponents = CGColorGetNumberOfComponents(color);

        if (numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            CGContextSetRGBFillColor(context, R, G, B, 1.0);
        }
        CGContextFillRect(context, lineRect);
    }
}

@end
