//
//  NXMultLabel.m
//  NXLib
//
//  Created by AK on 14-3-7.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXMultLabel.h"

#define Default_MutiText_Font [UIFont systemFontOfSize:16]
#define Default_MutiText_Color [UIColor blackColor]

@interface NXMultLabel ()
{
    NSString *showText;
    NSArray *setArray;
}
@property(retain, nonatomic) NSString *showText;
@property(retain, nonatomic) NSArray *setArray;
@end

@implementation NXMultLabel

@synthesize showText;
@synthesize setArray;

@synthesize alignmentType;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        alignmentType = Muti_Alignment_Left_Type;
    }
    return self;
}

- (void)dealloc
{
//使用ARC和不使用ARC
#if !__has_feature(objc_arc)

    [showText release];
    [setArray release];
    [super dealloc];
#endif
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSArray *subViews = [self subviews];
    if ([subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    NSArray *stringArray_f = [showText componentsSeparatedByString:@"|"];
    NSMutableArray *sizeArray_f = [[NSMutableArray alloc] initWithCapacity:5];
    int totalWidth_f = 0;
    float maxHeight_f = 0.0;
    for (int i = 0; i < [stringArray_f count]; i++)
    {
        NSString *str_f = [stringArray_f objectAtIndex:i];
        UIFont *font_f = Default_MutiText_Font;
        if (i < [setArray count])
        {
            NSDictionary *dic_f = [setArray objectAtIndex:i];
            if ([dic_f isKindOfClass:[NSDictionary class]])
            {
                font_f = [dic_f objectForKey:@"Font"] ? [dic_f objectForKey:@"Font"] : Default_MutiText_Font;
            }
        }
        CGSize strSize_f = [self getStringSizeByFont:font_f String:str_f];
        if (strSize_f.height > maxHeight_f)
        {
            maxHeight_f = strSize_f.height;
        }
        [sizeArray_f addObject:NSStringFromCGSize(strSize_f)];
        totalWidth_f += strSize_f.width;
    }

    int viewWidth_f = CGRectGetWidth(self.frame);
    int viewHeight_f = CGRectGetHeight(self.frame);
    int init_x = 0;
    int init_y = 0;

    switch (alignmentType)
    {
        case Muti_Alignment_Left_Type:
        {
            init_x = 0;
        }
        break;
        case Muti_Alignment_Mid_Type:
        {
            init_x = (viewWidth_f - totalWidth_f) / 2;
        }
        break;
        case Muti_Alignment_Right_Type:
        {
            init_x = (viewWidth_f - totalWidth_f);
        }
        break;
        default:
            break;
    }

    for (int i = 0; i < [stringArray_f count]; i++)
    {
        NSString *str_f = [stringArray_f objectAtIndex:i];
        UIColor *color_f = Default_MutiText_Color;
        UIFont *font_f = Default_MutiText_Font;
        if (i < [setArray count])
        {
            NSDictionary *dic_f = [setArray objectAtIndex:i];
            if ([dic_f isKindOfClass:[NSDictionary class]])
            {
                color_f = [dic_f objectForKey:@"Color"] ? [dic_f objectForKey:@"Color"] : Default_MutiText_Color;
                font_f = [dic_f objectForKey:@"Font"] ? [dic_f objectForKey:@"Font"] : Default_MutiText_Font;
            }
        }
        CGSize strSize_f = CGSizeFromString([sizeArray_f objectAtIndex:i]);
        init_y = (viewHeight_f + maxHeight_f - 2 * strSize_f.height) / 2;

        UILabel *tempLable_f = [[UILabel alloc] init];
        [tempLable_f setFrame:CGRectMake(init_x, init_y, strSize_f.width, strSize_f.height)];
        [tempLable_f setText:str_f];
        [tempLable_f setTextColor:color_f];
        [tempLable_f setFont:font_f];
        [tempLable_f setBackgroundColor:[UIColor clearColor]];
        [tempLable_f setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:tempLable_f];
        //        [tempLable_f release];

        init_x += strSize_f.width;
    }

    //    [sizeArray_f release];
}

- (CGSize)getStringSizeByFont:(UIFont *)font String:(NSString *)text
{
    CGSize strSize_f = CGSizeMake(0, 0);

    if ([text length] == 0)
    {
        return strSize_f;
    }

    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        strSize_f = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    }
    else
    {
        //        strSize_f = [text sizeWithFont:font];
    }
    return strSize_f;
}

- (void)setShowText:(NSString *)text Setting:(NSArray *)setDictionary
{
    if (![text isKindOfClass:[NSString class]] || ![setDictionary isKindOfClass:[NSArray class]])
    {
        return;
    }
    self.showText = text;
    self.setArray = setDictionary;
    [self setNeedsLayout];
}

@end
