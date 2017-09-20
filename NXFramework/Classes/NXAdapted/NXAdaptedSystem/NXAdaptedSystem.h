//
//  NXAdaptedSystem.h
//  NXlib
//
//  Created by AK on 5/4/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

/**
 *   系统版本适配
 */

#import <Foundation/Foundation.h>

/**
 *  检查是否iOS7+
 *
 *  @return YES 7.0+
 */
extern BOOL NXiOS7OrLater(void);

/**
 *  @brief 检查是否iOS8+
 */
extern BOOL NXiOS8OrLater(void);

/**
 *  @brief 获取适配的坐标(此坐标是基于iOS7+的坐标系)
 */
CG_EXTERN CGRect CGRectAdapt(CGFloat x, CGFloat y, CGFloat width, CGFloat height, BOOL adaptedStatusBar,
                             BOOL adaptedNavBar, BOOL adjustHeight);

@interface NXAdaptedSystem : NSObject

@end
