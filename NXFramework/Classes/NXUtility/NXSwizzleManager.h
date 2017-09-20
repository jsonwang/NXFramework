//
//  NXSwizzleManager.h
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

//本类功能:所有的代码注入操作都在这个类里面管理，降低与View
// Controller的耦合　要导入Aspects.h
// 在　didFinishLaunchingWithOptions　中直接调用　 [NXSwizzleManager
// createAllHooks];

#import "NXObject.h"

@interface NXSwizzleManager : NXObject

+ (void)createAllHooks;

@end
