//
//  NXBaseApiLogics.h
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXRequest.h"
@class NXBaseApiLogics;

@interface NXBaseApiLogics : NSObject<NXNetworkDelegate>

@property(weak)id<NXNetworkDelegate> apiDelegate;

@end

@interface NXBaseApiLogics(NXNetWorkUinity)

/**
 构建好 NXRequest后执行 [[self class] sendRequest:request]; 发送网络请求
 */
+(void)sendRequest:(NXRequest *)request;

@end
