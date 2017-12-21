//
//  NXRequest.m
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXRequest.h"
#import "NXBaseApiLogics.h"
@implementation NXRequest

- (void)setDelegate:(NXBaseApiLogics<NXNetworkDelegate> *)delegate
{
    BOOL valid = ([delegate isMemberOfClass:[NXBaseApiLogics class]]);
    NSAssert(!valid, @"delegate must is NXBaseApiLogics class or subClass");
    _delegate = delegate;
}
@end
