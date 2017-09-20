//
//  UIView+UIView_RoundedCorners.m
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "UIView+NXCategory.h"

static NSString *NXViewStringTagKey = @"NXViewStringTagKey";

@implementation UIView (NXCategory)

- (float)x { return self.nx_x; }
- (void)setX:(float)newX { self.nx_x = newX; }
- (float)y { return self.nx_y; }
- (void)setY:(float)newY { self.nx_y = newY; }
- (float)nx_x { return self.frame.origin.x; }
- (void)setNx_x:(float)newX
{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (float)nx_y { return self.frame.origin.y; }
- (void)setNx_y:(float)newY
{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}
- (void)setNx_width:(float)nx_width
{
    CGRect frame = self.frame;
    frame.size.width = nx_width;
    self.frame = frame;
}

- (float)nx_width { return self.frame.size.width; }
- (void)setNx_height:(float)nx_height
{
    CGRect frame = self.frame;
    frame.size.height = nx_height;
    self.frame = frame;
}

- (float)nx_height { return self.frame.size.height; }

- (CGFloat)nx_top
{
    return self.frame.origin.y;
}

- (void)setNx_top:(CGFloat)nx_y
{
    CGRect frame = self.frame;
    frame.origin.y = nx_y;
    self.frame = frame;
}

- (CGFloat)nx_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNx_Bottom:(CGFloat)nx_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = nx_bottom - frame.size.height;
    self.frame = frame;
}


//@property CGFloat nx_top;
//@property CGFloat nx_bottom;

#pragma mark - Frame
- (CGPoint)nx_middle { return CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0); }
- (CGSize)nx_orientationSize
{
    BOOL swap = !NXiOS8OrLater() && [NXSystemInfo isLandscape];
    return swap ? NXSizeSWAP(self.size) : self.size;
}

- (CGFloat)nx_orientationWidth { return self.nx_orientationSize.width; }
- (CGFloat)nx_orientationHeight { return self.nx_orientationSize.height; }
- (CGPoint)nx_orientationMiddle
{
    return CGPointMake(self.nx_orientationSize.width / 2.0, self.nx_orientationSize.height / 2.0);
}

- (void)nx_setStringTag:(NSString *)tag { [self setTag:[tag hash]]; }
- (UIView *)nx_getViewWithStringTag:(NSString *)tag { return [self viewWithTag:[tag hash]]; }
#pragma mark - Border radius

- (void)nx_rounded:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)nx_rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}

- (void)nx_border:(CGFloat)borderWidth color:(UIColor *)borderColor
{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}

- (void)nx_setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size
{
    UIBezierPath *maskPath =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];

    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)nx_circleView:(UIView *)view
    cuttingDirection:(UIRectCorner)direction
         cornerRadii:(CGFloat)cornerRadii
         borderWidth:(CGFloat)borderWidth
         borderColor:(UIColor *)borderColor
     backgroundColor:(UIColor *)backgroundColor
{
    if (view.bounds.size.height != 0 && view.bounds.size.width != 0)
    {
        //使用Masonry布局后，view的bounds是异步返回的，这里需要做初步的判断
        CGFloat width = view.bounds.size.width, height = view.bounds.size.height;

        UIImage *image = nil;
        //先利用CoreGraphics绘制一个圆角矩形
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef currnetContext = UIGraphicsGetCurrentContext();
        if (currnetContext)
        {
            if (backgroundColor == nil)
            {
                backgroundColor = [UIColor clearColor];
            }
            CGContextSetFillColorWithColor(currnetContext, backgroundColor.CGColor);  // 设置填充颜色
            CGContextSetStrokeColorWithColor(currnetContext, borderColor.CGColor);    // 设置画笔颜色

            if (cornerRadii == 0)
            {
                cornerRadii = view.bounds.size.height / 2;
            }
            // 单切全角
            if (direction == UIRectCornerAllCorners)
            {
                CGContextMoveToPoint(currnetContext, width - borderWidth, cornerRadii + borderWidth);  // 从右下开始
                CGContextAddArcToPoint(currnetContext, width - borderWidth, height - borderWidth,
                                       width - cornerRadii - borderWidth, height - borderWidth,
                                       cornerRadii);  // 右下角角度
                CGContextAddArcToPoint(currnetContext, borderWidth, height - borderWidth, borderWidth,
                                       height - cornerRadii - borderWidth, cornerRadii);  // 左下角角度
                CGContextAddArcToPoint(currnetContext, borderWidth, borderWidth, width - borderWidth, borderWidth,
                                       cornerRadii);  // 左上角
                CGContextAddArcToPoint(currnetContext, width - borderWidth, borderWidth, width - borderWidth,
                                       cornerRadii + borderWidth, cornerRadii);  // 右上角
            }
            else
            {
                // 单切左上角
                CGContextMoveToPoint(currnetContext, cornerRadii + borderWidth, borderWidth);  // 从左上开始
                if (direction & UIRectCornerTopLeft)
                {
                    CGContextAddArcToPoint(currnetContext, borderWidth, borderWidth, borderWidth,
                                           cornerRadii + borderWidth, cornerRadii);  // 左上角
                }
                else
                {
                    CGContextAddLineToPoint(currnetContext, borderWidth, borderWidth);
                }
                if (direction & UIRectCornerBottomLeft)
                {
                    CGContextAddArcToPoint(currnetContext, borderWidth, height - borderWidth, borderWidth + cornerRadii,
                                           height - borderWidth, cornerRadii);
                }
                else
                {
                    CGContextAddLineToPoint(currnetContext, borderWidth, height - borderWidth);  // 左侧线
                }
                if (direction & UIRectCornerBottomRight)
                {
                    CGContextAddArcToPoint(currnetContext, width - borderWidth, height - borderWidth,
                                           width - borderWidth, height - borderWidth - cornerRadii, cornerRadii);
                }
                else
                {
                    CGContextAddLineToPoint(currnetContext, width - borderWidth, height - borderWidth);  // 底部线
                }
                if (direction & UIRectCornerTopRight)
                {
                    CGContextAddArcToPoint(currnetContext, width - borderWidth, borderWidth,
                                           width - borderWidth - cornerRadii, borderWidth, cornerRadii);
                }
                else
                {
                    CGContextAddLineToPoint(currnetContext, height - borderWidth, borderWidth);  // 右侧线
                }
                CGContextAddLineToPoint(currnetContext, borderWidth + cornerRadii, borderWidth);
            }

            CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        // 绘制完成后，将UIImageView插入到view视图层级的底部
        if ([image isKindOfClass:[UIImage class]])
        {
            UIImageView *baseImageView = [[UIImageView alloc] initWithImage:image];
            [view insertSubview:baseImageView atIndex:0];
        }
    }
    else
    {
        NSLog(@"circle view error! %@",view);
    }
}

#pragma mark - Animation

+ (void)nx_animateFollowKeyboard:(NSDictionary *)userInfo
                      animations:(void (^)(NSDictionary *userInfo))animations
                      completion:(void (^)(BOOL finished))completion
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;

    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];

    UIViewAnimationOptions options = ((animationCurve << 16) | UIViewAnimationOptionBeginFromCurrentState);

    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:options
                     animations:^{
                         if (animations)
                         {
                             animations(userInfo);
                         }
                     }
                     completion:completion];
}

#pragma mark - Public Method

- (UIView *)nx_firstResponder
{
    if ([self isFirstResponder])
    {
        return self;
    }
    UIView *firstResponder = nil;
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews)
    {
        firstResponder = [subview nx_firstResponder];
        if (firstResponder)
        {
            return firstResponder;
        }
    }
    return nil;
}

@end

