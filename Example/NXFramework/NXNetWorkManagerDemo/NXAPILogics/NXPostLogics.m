//
//  NXPostLogics.m
//  NXFramework
//
//  Created by liuming on 2017/10/27.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXPostLogics.h"


@implementation NXPostLogics{

    NSArray * _args;
}

- (instancetype) initWithValues:(NSArray<NSString * > *)args
{

    self = [super init];
    if (self) {
        
        _args = args;
    }
    
    return self;
}
- (NSString *)baseUrl
{

    return @"https://httpbin.org/";
}
- (NSString *)requestAPIPath
{
    return @"post";
}
- (NXHTTPMethodType)requestMethod
{
    return NXHTTPMethodTypeOfPOST;
}

- (void)requestParams:(id<NXContainerProtol>)params
{
    for (NSInteger i = 0; i < _args.count; i ++)
    {
        NSString * key = [NSString stringWithFormat:@"agr_key_%ld",(long)i];
        params.addString(key,_args[i]);
    }
}
- (NXNWRequest *)buildCustomRequest
{
    NXNWRequest * request = [[NXNWRequest alloc] init];
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    return request;
}
@end
