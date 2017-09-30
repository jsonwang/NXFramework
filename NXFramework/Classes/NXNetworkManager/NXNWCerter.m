//
//  NXNWCerter.h.m
//  NXNetworkManager
//
//  Created by 明刘 on 2017/9/9.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNWCerter.h"
#import "NXNWRequest.h"
#import "NXNWBridge.h"
#import "NXNWConfig.h"

@interface NXNWCerter ()
@property(nonatomic,strong)NSMutableDictionary<NSString *,id> * batchAndChainRequestPool;
@property(nonatomic,strong) NSLock * lock;
@end
@implementation NXNWCerter

- (NXNWBridge *)brdge
{
    return [NXNWBridge shareInstaced];
}
+(instancetype) shareInstanced{
    
    static  NXNWCerter * nx_center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        nx_center = [[NXNWCerter alloc] init];
    });
    
    return nx_center;
}

- (NSMutableDictionary<NSString *,id> * )batchAndChainRequestPool{
    
    if (_batchAndChainRequestPool == nil) {
        
        _batchAndChainRequestPool = [[NSMutableDictionary alloc] init];
    }
    
    return _batchAndChainRequestPool;
}
#pragma mark -
- (NSString *) sendRequset:(NXNWRequest *)requset{
    
    return [self sendRequset:requset progress:requset.progressHandlerBlock];
}
- (NSString *) sendRequset:(NXNWRequest *)requset progress:(NXProgressBlock) progressBlock
{
    return [self sendRequset:requset progress:progressBlock succes:requset.succesHandlerBlock failure:requset.failureHandlerBlock];
}
- (NSString *) sendRequset:(NXNWRequest *)requset succes:(NXSuccesBlock)succes failure:(NXFailureBlock)failure{
    
    return [self sendRequset:requset progress:requset.progressHandlerBlock succes:succes failure:failure];
}
- (NSString *)sendRequset:(NXNWRequest *)requset progress:(NXProgressBlock) progressBlock succes:(NXSuccesBlock) succes failure:(NXFailureBlock) failue{
    
    requset.progressHandlerBlock = progressBlock;
    requset.succesHandlerBlock = succes;
    requset.failureHandlerBlock = failue;
    //请求正式发起前的回调
    if (requset.requestProcessHandler) {
        
        requset.requestProcessHandler(requset);
    }
    //合并公共请求参数
    [self nx_processParams:requset];
    //合并公共请求头
    [self nx_processHeaders:requset];
    
    return  [self nx_sendRequest:requset];
}

-(void)nx_processParams:(NXNWRequest *)request{
    
    if (!request.ingoreDefaultHttpParams){
        //不忽略 合并请求参数
        NXContainer * paramContainer = [[NXContainer alloc] init];
        NSDictionary * httpParams = [request.params containerConfigDic];
        NSDictionary * defaultDic = [request.config.globalParams containerConfigDic];
        [defaultDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            paramContainer.addString(key,obj);
        }];
        
        [httpParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            paramContainer.addString(key,obj);
        }];
        
        request.params = paramContainer;
    }
}

- (void)nx_processHeaders:(NXNWRequest *)request{
    
    if (!request.ingoreDefaultHttpHeaders) {
        //不忽略 合并请求头
        NXContainer * headers = [[NXContainer alloc] init];
        NSDictionary * httpHeadDic = [request.headers containerConfigDic];
        NSDictionary * defaultDic  = [request.config.globalHeaders containerConfigDic];
        
        [defaultDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            headers.addString(key,obj);
        }];
        
        [httpHeadDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            headers.addString(key,obj);
        }];
        
        request.headers = headers;
    }
}

- (NSString *)nx_sendRequest:(NXNWRequest *)request{
    
    if (request.config.consoleLog) {
        
        if (request.requstType == NXNWRequestTypeDownload) {
            NSLog(@"\n============ [NXNWRequest Info] ============\nrequest download url: %@\nrequest save path: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.fullUrl, request.fileUrl, request.headers.containerConfigDic, request.params.containerConfigDic);
        } else {
            NSLog(@"\n============ [NXNWRequest Info] ============\nrequest url: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.fullUrl, request.headers.containerConfigDic, request.params.containerConfigDic);
        }
    }
    
    [self.brdge sendWithRequst:request completionHandler:^(id responseObject, NSError *error) {
        if (!error) {
            
            [self nx_succes:responseObject request:request];
        } else {
            
            [self nx_failure:error withRequest:request];
        }
    }];
    return request.identifier;
}
- (void)nx_succes:(id)reponseObj request:(NXNWRequest *)request
{
    NSError * error;
    if (request.requestProcessHandler) {
        request.responseProcessHandler(request, reponseObj, &error);
    }
    if(error)
    {
        [self nx_failure:error withRequest:request];
        return ;
    }
    if (request.config.consoleLog) {
        
        if (request.requstType == NXNWRequestTypeNormal) {
            
            NSLog(@"\n============ [NXResponse Data] ===========\nrequest download url: %@\nresponse data: %@\n==========================================\n", request.url, reponseObj);
            
        } else if (request.resopseSerializer == NXHTTResposeSerializerTypeRAW){
            
            NSLog(@"\n============ [NXResponse Data] ===========\nrequest url: %@ \nresponse data: \n%@\n==========================================\n", request.fullUrl, [[NSString alloc] initWithData:reponseObj encoding:NSUTF8StringEncoding]);
            
        } else {
            
            NSLog(@"\n============ [NXResponse Data] ===========\nrequest url: %@ \nresponse data: \n%@\n==========================================\n", request.url, reponseObj);
        }
    }
    __weak typeof(self) weakSelf = self;
    if (request.config.callbackQueue) {
        
        dispatch_async(request.config.callbackQueue, ^{
            
            __strong typeof(weakSelf) strongSelft = weakSelf;
            [strongSelft runSuccesHandler:reponseObj withRequest:request];
        });
    } else {
        
        [self runSuccesHandler:reponseObj withRequest:request];
    }
}

-(void)nx_failure:(NSError *)error withRequest:(NXNWRequest *)request{
    
    if (request.config.consoleLog) {
        
        NSLog(@"\n=========== [NXResponse Error] ===========\n request url: %@ \n error info: \n%@\n==========================================\n retyCount = %ld", request.url, error,(long)request.retryCount);
    }
    if (request.retryCount<= 0) {
        
        if (request.config.callbackQueue) {
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(request.config.callbackQueue, ^{
                
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf runFailureHandler:error withRequest:request];
            });
        } else {
            
            [self runFailureHandler:error withRequest:request];
        }
        
    } else{
        
        //两秒后 自动调试
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            request.retryCount = request.retryCount -1;
            [self nx_sendRequest:request];
        });
    }
    
}
- (void)runFailureHandler:(NSError *)error withRequest:(NXNWRequest *)request{
    
    if (request.failureHandlerBlock) {
        
        request.failureHandlerBlock(error, request);
    }
    
    [request cleanHandlerBlock];
}

-(void)runSuccesHandler:(id)resposeObj withRequest:(NXNWRequest *)request{
    
    if (request.succesHandlerBlock) {
        
        request.succesHandlerBlock(resposeObj, request);
    }
    [request cleanHandlerBlock];
}


#pragma mark - 批量处理模块
/**
 发起批量请求
 
 @param bRequest 请求request
 */
- (NSString * )sendBatchRequest:(NXBatchRequest *)bRequest{
    
    return [self sendBatchRequest:bRequest success:bRequest.successBlock failure:bRequest.failureBlock];
}


/**
 发起批量请求
 @param bRequest 请求request
 @param success 成功回调
 @param failure 失败回调
 */
- (NSString *)sendBatchRequest:(NXBatchRequest *)bRequest success:(NXBatchSuccessBlock)success failure:(NXBatchFailureBlock)failure{
    
    if(bRequest.requestPool.count > 0){
        bRequest.successBlock = success;
        bRequest.failureBlock = failure;
        [bRequest.responsePool removeAllObjects];
        
        for (NXNWRequest * requst in bRequest.requestPool) {
            [bRequest.responsePool addObject:[NSNull null]];
            __weak typeof(self) weakSelf = self;
            [requst startWithSucces:^(id responseObject, NXNWRequest *rq) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf nx_processBatch:requst batchRequest:bRequest responseObj:responseObject error:nil];
                
            } failure:^(NSError *error, NXNWRequest *rq) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf nx_processBatch:requst batchRequest:bRequest responseObj:nil error:error];
            }];
        }
        [self.lock lock];
        NSString * identifier = [self nx_identifierForBatchAndChainRequest];
        bRequest.identifier = identifier;
        [self.batchAndChainRequestPool setObject:bRequest forKey:identifier];
        [self.lock unlock];
        return identifier;
    } else {
        
        return nil;
    }
    
}

- (void)nx_processBatch:(NXNWRequest*)request batchRequest:(NXBatchRequest *)bRequest responseObj:(id)response error:(NSError *)error{
    
    [self.lock lock];
    if ([bRequest onFinish:request reposeObject:response error:error]) {
        
        [self.batchAndChainRequestPool removeObjectForKey:bRequest.identifier];
    }
    [self.lock unlock];
    
}

- (NSString *)nx_identifierForBatchAndChainRequest{
    
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"BC%lld",time];
}

#pragma mark - 链式请求

- (NSString *) sendChainRequst:(NXChainRequest *)chainRequet{
    
    return [self sendChainRequest:chainRequet success:chainRequet.succesBlock failure:chainRequet.failureBlock];
}

- (NSString *)sendChainRequest:(NXChainRequest *)chainRequet success:(NXChainSuccessBlock) success failure:(NXChainFailureBlock)failure{
    
    
    chainRequet.succesBlock = success;
    chainRequet.failureBlock = failure;
    [self nx_runNextChainRequest:chainRequet];
    NSString * identifier = [self nx_identifierForBatchAndChainRequest];
    chainRequet.identifier = identifier;
    [self.lock lock];
    [self.batchAndChainRequestPool setObject:chainRequet forKey:identifier];
    [self.lock unlock];
    return identifier;
}

- (void)nx_processChainRequest:(NXNWRequest*)request chainRequest:(NXChainRequest *)chainRequest responseObj:(id)response error:(NSError *)error{
    
    [self.lock lock];
    
    if ([chainRequest oneRequestFinish:request responseObj:response error:error]) {
        
        [self.batchAndChainRequestPool removeObjectForKey:chainRequest.identifier];
    } else {
        
        [self nx_runNextChainRequest:chainRequest];
    }
    [self.lock unlock];
    
}
- (void)nx_runNextChainRequest:(NXChainRequest *)chainRequest{
    
    NXNWRequest * request = [chainRequest nextRequst];
    if (request) {
        __weak typeof(self) weakSelf = self;
        [self sendRequset:request succes:^(id responseObject, NXNWRequest *rq) {
            [weakSelf nx_processChainRequest:request chainRequest:chainRequest responseObj:responseObject error:nil];
        } failure:^(NSError *error, NXNWRequest *rq) {
            
            [weakSelf nx_processChainRequest:request chainRequest:chainRequest responseObj:nil error:error];
        }];
    }
}
#pragma mark -

- (void)pasueRequest:(NSString *)identifier
{
    [[NXNWBridge shareInstaced] pauseRequest:identifier];
}
- (void)cancleRequest:(NSString *)identifier
{
    [[NXNWBridge shareInstaced] cancleRequst:identifier];
    
    
}
- (void)resumeRequest:(NSString *)identifier request:(NXNWRequest *)request{
    
    [[NXNWBridge shareInstaced] resumeRequest:identifier];
}
- (id)getRequest:(NSString *)identifier{
    
    return [[NXNWBridge shareInstaced] getRequestByIdentifier:identifier];
}

- (void)addSSLPinningURL:(NSString *)url{
    
    [self.brdge addSSLPinningURL:url];
    
}
- (void)addSSLPinningCert:(NSData *)cert{
    
    [self.brdge addSSLPinningCert:cert];
}
- (void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password
{
    [self.brdge addTwowayAuthenticationPKCS12:p12 keyPassword:password];
}
@end
