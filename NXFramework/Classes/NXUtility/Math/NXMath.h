//
//  NXMath.h
//  NXlib
//
//  Created by AK on 5/4/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

/**
 *  是否等于零
 */
static inline BOOL NXMathEqualZero(double number)
{
    const double EPSINON = 1.00e-07;  //此处根据精度定
    return (number >= -EPSINON) && (number <= EPSINON);
}

/**
 *  四舍五入
 *
 *  @param number 数字
 *  @param digit  小数点位数
 */
static inline CGFloat NXMathRound(CGFloat number, NSInteger digit)
{
    double powNum = pow(10, digit);
    return round(number * powNum) / powNum;
}

/**
 *  数字一半
 */
static inline CGFloat NXMathHalf(CGFloat number) { return number / 2.0; };
/**
 *  数字两倍
 */
static inline CGFloat NXMathDouble(CGFloat number) { return number * 2.0; };
/**
 *  角度转弧度
 */
static inline CGFloat NXMathDegreesToRadians(CGFloat degrees) { return degrees * (M_PI / 180); };
/**
 *  弧度转角度
 */
static inline CGFloat NXMathRadiansToDegrees(CGFloat radians) { return radians * (180 / M_PI); };
/**
 *  数字交换
 */
static inline void NXMathSWAP(CGFloat *a, CGFloat *b)
{
    CGFloat t;
    t = *a;
    *a = *b;
    *b = t;
};

/**
 *  取整
 */
static inline CGFloat NXRectRound(CGFloat number) { return ceil(number); }
/**
 *  上取整(不小于/大于等于)
 */
static inline CGFloat NXRectCeil(CGFloat number) { return ceil(number); }
/**
 *  下取整(不大于/小于等于)
 */
static inline CGFloat NXRectFloor(CGFloat number) { return floor(number); }
/**
 *  交换高度与宽度
 */
static inline CGSize NXSizeSWAP(CGSize size) { return CGSizeMake(size.height, size.width); }
/**
 *  根据字体像素(px)大小获取字体磅(pt)大小
 */
// static inline CGFloat NXFontSizeFromPx(CGFloat px) {
//    return 0;
//}

@interface NXMath : NSObject

@end
