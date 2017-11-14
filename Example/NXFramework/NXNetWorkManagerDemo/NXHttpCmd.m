//
//  NXHttpcmd.m
//  NXFramework
//
//  Created by liuming on 2017/10/26.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXHttpCmd.h"

@implementation NXHttpCmd

- (instancetype) initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
       
        self.url = baseUrl;
        [self initDefaultValue];
    }
    
    return self;
    
}
- (instancetype) initWithWithApiPath:(NSString *)apiPath
{
    self = [super init];
    if (self) {
        
        self.apiPath = apiPath;
        [self initDefaultValue];
    }
    
    return self;
    
}
- (instancetype)init
{
     return [self initWithBaseUrl:nil];
}

- (void)initDefaultValue
{
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    self.requstSerializer = NXHTTPRrequstSerializerTypeJSON;
    self.resopseSerializer = NXHTTResposeSerializerTypeJSON;
    self.requstType = NXNWRequestTypeNormal;
    self.timeOutInterval = 10.0f;
    self.isBreakpoint = YES;
    self.httpMethod = NXHTTPMethodTypeOfGET;
    self.ingoreDefaultHttpHeaders = NO;
    self.ingoreDefaultHttpParams = NO;
    self.allowRepeatHttpRequest = NO;
    self.retryCount = 0;
    
}

- (id<NXContainerProtol>)params{

    if (_params == nil) {
        
        _params = [[NXContainer alloc] init];
    }
    
    return _params;
}
@end
