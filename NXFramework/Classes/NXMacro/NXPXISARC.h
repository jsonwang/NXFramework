//
//  NXPXISARC.h
//  IntelligentHome
//
//  Created by AK on 14-5-2.
//  Copyright (c) 2014年 dekeqin. All rights reserved.
//

/**
 *  MRC ARC 适配写法
 *
 */

#ifndef IntelligentHome_NXPXISARC_h
#define IntelligentHome_NXPXISARC_h

#ifndef PX_STRONG
#if __has_feature(objc_arc)
#define PX_STRONG strong
#else
#define PX_STRONG retain
#endif
#endif

#ifndef PX_WEAK
#if __has_feature(objc_arc_weak)
#define PX_WEAK weak
#elif __has_feature(objc_arc)
#define PX_WEAK unsafe_unretained
#else
#define PX_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define PX_AUTORELEASE(expression) expression
#define PX_RELEASE(expression) expression
#define PX_RETAIN(expression) expression
#else
#define PX_AUTORELEASE(expression) [expression autorelease]
#define PX_RELEASE(expression) [expression release]
#define PX_RETAIN(expression) [expression retain]
#endif

#endif
