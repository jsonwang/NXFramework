//
//  NXTestLogics.h
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXBaseApiLogics.h"

@interface NXTestLogics : NXBaseApiLogics

- (instancetype) initWithApiDelegate:(id<NXNetworkDelegate>)apiDelegate;

- (void)testwithUrl:(NSString *)url msgid:(int)msgid;//get

- (void)testwithUrl:(NSString *)url msgid:(int)msgid;//post
@end
