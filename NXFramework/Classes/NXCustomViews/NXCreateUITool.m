//
//  NXCreateUITool.m
//  NX
//
//  Created by 王成 on 14-8-3.
//  Copyright (c) 2014年 NX-corp.com. All rights reserved.
//

#import "NXCreateUITool.h"

#import "UIControl+NXCategory.h"
#import "NXConfig.h"

/////////////////////////////////////////////////////////

#define NX_BASE_TEXT_COLOR NX_UIColorFromRGB(0xffffff)

#define NX_FONT_18 18

#define NX_FONT_14 14

#define NX_COLOR_LINE_GRAY NX_UIColorFromRGB(0xdcdcdc)  // 分割线


@implementation NXCreateUITool
// uilabel
+ (UILabel *)createLabelInitWithFrame:(CGRect)frame
                      backgroundColor:(UIColor *)backColor
                        textAlignment:(NSTextAlignment)alignment
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                                 font:(UIFont *)font
                            superView:(UIView *)superView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = backColor;
    titleLabel.textAlignment = alignment;
    titleLabel.text = text;
    titleLabel.textColor = textColor;
    titleLabel.font = font;
    if (superView)
    {
        [superView addSubview:titleLabel];
    }
    return titleLabel;
}

// uiimage
+ (UIImageView *)createImageViewWithPoint:(CGPoint)point fileName:(NSString *)fileName superView:(UIView *)superView
{
    UIImage *image = [UIImage imageNamed:fileName];

    UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
    [imageView setImage:image];
    if (superView)
    {
        [superView addSubview:imageView];
    }

    return imageView;
}

+ (UIButton *)createButtonWithPoint:(CGPoint)point
                normalImageFileName:(NSString *)normalImageFileName
                  highlightFileName:(NSString *)highlightFileName
                          superView:(UIView *)superView
{
    UIImage *normalImage = [UIImage imageNamed:normalImageFileName];
    UIButton *btn =
        [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, normalImage.size.width, normalImage.size.height)];
    //    btn.uxy_acceptEventInterval=0.2;

    btn.exclusiveTouch = YES;
    [btn setTitleColor:NX_BASE_TEXT_COLOR forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    if (highlightFileName && highlightFileName.length > 0)
    {
        [btn setBackgroundImage:[UIImage imageNamed:highlightFileName] forState:UIControlStateHighlighted];
    }

    if (superView)
    {
        [superView addSubview:btn];
    }

    return btn;
}
+ (UIButton *)createTextButtonWithPoint:(CGPoint)point title:(NSString *)titleStr superView:(UIView *)superView
{
    UIButton *_backBtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 64, 44)];
    //    _backBtn.uxy_acceptEventInterval=0.2;

    _backBtn.exclusiveTouch = YES;
    _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _backBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _backBtn.backgroundColor = [UIColor clearColor];

    _backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_backBtn setTitle:titleStr forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:NX_FONT_18];
    [_backBtn setTitleColor:NX_BASE_TEXT_COLOR forState:UIControlStateNormal];
    [superView addSubview:_backBtn];
    return _backBtn;
}
+ (UIButton *)createButtonWithRect:(CGRect)rect superView:(UIView *)superView
{
    UIButton *btn =
        [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    //    btn.uxy_acceptEventInterval=0.2;
    btn.backgroundColor = [UIColor clearColor];
    btn.exclusiveTouch = YES;
    [btn setTitleColor:NX_BASE_TEXT_COLOR forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    if (superView)
    {
        [superView addSubview:btn];
    }

    return btn;
}
+ (UIButton *)createTextAndImageButtonWithRect:(CGRect)rect
                                         image:(NSString *)imageName
                                          text:(NSString *)title
                                     superView:(UIView *)superView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    //    btn.uxy_acceptEventInterval=0.2;
    btn.exclusiveTouch = YES;
    [btn setBackgroundColor:[UIColor clearColor]];

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    UIImage *image = [UIImage imageNamed:imageName];
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:NX_UIColorFromRGB(0x868686) forState:UIControlStateNormal];

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];

    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = NX_UIColorFromRGB(0xe6e6e6).CGColor;
    [superView addSubview:btn];

    return btn;
}

+ (UIButton *)createButtonWithImage:(NSString *)imageName
                               text:(NSString *)title
                               rect:(CGRect)rect
                          superView:(UIView *)superView
{
    UIButton *btn =
        [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    btn.backgroundColor = [UIColor clearColor];
    btn.exclusiveTouch = YES;
    //    btn.uxy_acceptEventInterval=0.2;

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    UIImage *image = [UIImage imageNamed:imageName];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];

    [btn setTitleColor:NX_UIColorFromRGB(0x696969) forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:NX_FONT_14];

    [superView addSubview:btn];

    return btn;
}
+ (UIImageView *)createSeparatorLineWithPoint:(CGPoint)point superView:(UIView *)superView
{
    UIImageView *separatorLineView =
        [[UIImageView alloc] initWithFrame:CGRectMake(point.x * (NX_MAIN_SCREEN_WIDTH / 320.), point.y,
                                                      NX_MAIN_SCREEN_WIDTH - 2 * point.x * (NX_MAIN_SCREEN_WIDTH / 320.), 0.5)];
    separatorLineView.backgroundColor = NX_COLOR_LINE_GRAY;

    [superView addSubview:separatorLineView];

    return separatorLineView;
}
+ (UIImageView *)createVerticalLineWithPoint:(CGPoint)point height:(float)height superView:(UIView *)superView
{
    UIImageView *separatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 1 / 2., height)];

    separatorLineView.backgroundColor = NX_COLOR_LINE_GRAY;
    [superView addSubview:separatorLineView];

    return separatorLineView;
}
+ (UIBarButtonItem *)navigationItemWithNameString:(NSString *)name
                                           Target:(id)target
                                           action:(SEL)action
                                           isleft:(BOOL)isleft
                                             font:(UIFont *)font

{
    UIButton *naviBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (name.length > 2) ? 64 : 44, 44)];
    naviBtn.exclusiveTouch = YES;
    [naviBtn setTitle:name forState:UIControlStateNormal];
    if (name.length == 4)
    {
        [naviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [naviBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    naviBtn.titleLabel.font = font;
    [naviBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    naviBtn.contentHorizontalAlignment =
        isleft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    //    [naviBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    UIBarButtonItem *naviBtnItem = [[UIBarButtonItem alloc] initWithCustomView:naviBtn];
    return naviBtnItem;
}

+ (UIBarButtonItem *)navigationItemBackImage:(UIImage *)naviImage
                                 highlighted:(UIImage *)hightLightedImage
                                      Target:(id)target
                                      action:(SEL)action
                                      isLeft:(BOOL)isleft
{
    UIButton *naviBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, naviImage.size.width, naviImage.size.height)];
    //    naviBtn.uxy_acceptEventInterval=0.2;

    naviBtn.exclusiveTouch = YES;
    if (naviImage)
    {
        [naviBtn setImage:naviImage forState:UIControlStateNormal];
    }
    if (hightLightedImage)
    {
        [naviBtn setImage:hightLightedImage forState:UIControlStateHighlighted];
    }

    if (isleft)
    {
        naviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        naviBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
    {
        naviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        naviBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (action)
    {
        [naviBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (!naviImage || !hightLightedImage)
    {
        NSLog(@"navigationImage is nil");
    }
    UIBarButtonItem *naviBtnItem = [[UIBarButtonItem alloc] initWithCustomView:naviBtn];
    return naviBtnItem;
}

+ (UILabel *)setNavigationItmeTitleView:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];

    [titleLable setFont:[UIFont systemFontOfSize:18]];
    titleLable.center = CGPointMake(NX_MAIN_SCREEN_WIDTH / 2., 22);
    titleLable.textColor = NX_UIColorFromRGB(0x797979);
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;

    return titleLable;
}
 

@end
