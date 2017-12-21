//
//  NXTestLogics.m
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXTestLogics.h"

@implementation NXTestLogics

- (instancetype) initWithApiDelegate:(id<NXNetworkDelegate>)apiDelegate
{
    self = [super init];
    if (self)
    {
        self.apiDelegate = apiDelegate;
    }
    return self;
}

- (void)testwithUrl:(NSString *)url
{
    NXRequest * request = [[NXRequest alloc] initWithUrl:url];
    request.msgId = 100;
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    request.delegate = self;
    [[self class] sendRequest:request];
}
@end
