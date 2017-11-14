//
//  NXAPILogics.m
//  NXFramework
//
//  Created by liuming on 2017/10/26.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXAPILogics.h"
#define HTTP_REQUEST_SUCCESS_KEY @"HTTP_REQUEST_SUCCESS_KEY"
#define HTTP_REQUEST_PROGRESS_KEY @"HTTP_REQUEST_SUCCESS_KEY"
#define HTTP_REQUEST_FAILURE_KEY @"HTTP_REQUEST_FAILURE_KEY"

#define kDataCarried @"kDataCarried"
@interface NXAPILogics()

@property(nonatomic,strong) NXNWRequest * request;
@property(nonatomic,strong) NSMutableDictionary * obseverKeys;
@end
@implementation NXAPILogics

- (instancetype) init{

    self = [super init];
    if (self)
    {    
        [self initConfig];
    }
    
    return  self;
}
- (void)initRequest
{
    self.request = [self buildCustomRequest];
    if(self.request == nil)
    {
        self.request = [[NXNWRequest alloc] init];
    }
    self.request.url = [self baseUrl];
    self.request.apiPath = [self requestAPIPath];
    self.request.timeOutInterval = [self requestTimeoutInterval];
    self.request.httpMethod = [self requestMethod];
    self.request.resopseSerializer = [self responseSerializerType];
    [self requestParams:self.request.params];
    [self requestHeaders:self.request.headers];
}
- (void)regisertNotiSuccessKey:(NSString *)successKey failureKey:(NSString *)failureKey progressKey:(NSString *) progressKey{

    if(![NSString nx_isBlankString:successKey])
    {
        self.obseverKeys[HTTP_REQUEST_SUCCESS_KEY] = successKey;
    }
    if (![NSString nx_isBlankString:failureKey])
    {
        self.obseverKeys[HTTP_REQUEST_FAILURE_KEY] = failureKey;
    }
    if (![NSString nx_isBlankString:progressKey])
    {
        self.obseverKeys[HTTP_REQUEST_PROGRESS_KEY] = progressKey;
    }
}
/**
 开始请求
 */
- (void)start
{
    [self nx_startWithProgressCallBack:NO];
}
- (void)startWithProgress
{
    [self nx_startWithProgressCallBack:YES];
}
- (void)nx_startWithProgressCallBack:(BOOL)isOpen{

    [self initRequest];
    NXProgressBlock progressBlock = nil;
     __weak typeof(self) weakSelf = self;
    if (isOpen)
    {
        progressBlock = ^(NSProgress *progress)
        {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf nx_httpProgressCallBackHandler:progress];
            
        };
    }
    NXSuccesBlock succesBlock = ^(id responseObject, NXNWRequest *rq)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf nx_httpSuccesCallBackHandler:responseObject];
        
    };
    NXFailureBlock failureBlock = ^(NSError *error, NXNWRequest *rq)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf nx_httpFailureCallBackHandler:error];
        
    };
    
    [self.request startWithProgress:progressBlock
                            success:succesBlock
                            failure:failureBlock];
    
}
#pragma mark callBackHandler

- (void)nx_httpSuccesCallBackHandler:(id)responseObject
{
    _responseObj = responseObject;
    [self runOnMainThread:^{
        
        if (self.delegate) {
            
            if ([self.delegate respondsToSelector:@selector(httpRequestSuccess:)])
            {
                [self.delegate httpRequestSuccess:self];
            }
        }  else {
        
            NSString * notiName = self.obseverKeys[HTTP_REQUEST_SUCCESS_KEY];
            [self postNotication:notiName object:self];
        }
    }];
}

- (void)nx_httpFailureCallBackHandler:(NSError *)error
{

    _error = error;
    [self runOnMainThread:^{
        
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(httpRequstFailure:)]) {
                
                [self.delegate httpRequstFailure:self];
            }
            
        }  else {
            
            NSString * notiName = self.obseverKeys[HTTP_REQUEST_FAILURE_KEY];
            [self postNotication:notiName object:self];
            
        }
        
    }];
}

- (void)nx_httpProgressCallBackHandler:(NSProgress *) progress
{
    _progress = progress;
    [self runOnMainThread:^{
        
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(httpRequsetProgress:)])
            {
                [self.delegate httpRequsetProgress:self];
            }
            
        }  else {
            
            NSString * notiName = self.obseverKeys[HTTP_REQUEST_PROGRESS_KEY];
            [self postNotication:notiName object:self];
        }
    }];
}

- (void)runOnMainThread:(void(^)(void))block{

    if ([NSThread isMainThread]) {
        
        if (block) {
            
            block();
        }
    } else {
    
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)postNotication:(NSString *)notiName object:(id)object
{
    if ([NSString nx_isBlankString:notiName])
    {
        return;
    }
    
    NSDictionary * userInfo = nil;
    if (object) {
        
        userInfo = [NSDictionary dictionaryWithObject:object forKey:kDataCarried];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil userInfo:userInfo];
}
#pragma mark --
/**
 取消请求
 */
- (void)cancel{

    [self.request cancelRequset];
}

/**
 暂停请求
 */
- (void)pause
{
    [self.request pauseRequest];
}
/**
 恢复已经暂停的请求
 */
- (void)resume
{
    [self.request resumeRequst];
}

- (BOOL)isValidHttpUrl:(NSString *) url
{
    return [url nx_isValidateUrl];
}

- (NSMutableDictionary *)obseverKeys
{
    if (_obseverKeys == nil) {
        
        _obseverKeys = [[NSMutableDictionary alloc] init];
    }
    
    return _obseverKeys;
}
#pragma mark -- initConfig
- (void) initConfig{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [NXNWConfig shareInstanced].baseUrl = @"http://data.philm.cc/sticker/2017/v18/";
        [NXNWConfig shareInstanced].globalParams.addString(@"param1",@"1234");
        [NXNWConfig shareInstanced].globalParams.addString(@"param2",@"1234");
        [NXNWConfig shareInstanced].globalParams.addString(@"param3",@"1234");
        [NXNWConfig shareInstanced].globalParams.addString(@"param4",@"1234");
        
        [NXNWConfig shareInstanced].globalHeaders.addString(@"header1",@"1234");
        [NXNWConfig shareInstanced].globalHeaders.addString(@"header2",@"1234");
        [NXNWConfig shareInstanced].globalHeaders.addString(@"header3",@"1234");
        [NXNWConfig shareInstanced].globalHeaders.addString(@"header4",@"1234");
        [NXNWConfig shareInstanced].consoleLog = YES;
    });
}

#pragma mark -- 

- (NSString *)baseUrl
{

    return @"";
}

- (NSString *)requestAPIPath
{
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval{

    return  10.0f;
}

- (NXHTTPMethodType)requestMethod
{

    return  NXHTTPMethodTypeOfGET;
}

- (NXResposeSerializerType)responseSerializerType
{
    return  NXHTTResposeSerializerTypeJSON;
}
- (void)requestParams:(id<NXContainerProtol>)params
{

}
- (void)requestHeaders:(id<NXContainerProtol>)headers
{
    
}
-(NXNWRequest *)buildCustomRequest
{
    return nil;
}

- (void)dealloc{

    NSLog(@" APILogics dealloc");
}
@end
