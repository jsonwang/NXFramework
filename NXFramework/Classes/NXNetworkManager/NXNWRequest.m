//
//  NXNWRequest.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/8/10.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNWRequest.h"
#import "NXNWConfig.h"
#import "NXNWCerter.h"

@interface NXNWRequest (){

    NSString * _fullUrl;
}

@end

@implementation NXNWRequest

- (instancetype) initWithUrl:(NSString * )url{

    self = [super init];
    if (self) {
        
        self.url = url;
        
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.requstSerializer = NXHTTPRrequstSerializerTypeRAW;
        self.resopseSerializer = NXHTTResposeSerializerTypeJSON;
        self.requstType = NXNWRequestTypeNormal;
        self.allowRepeatHttpRequest = NO;
        self.config = [NXNWConfig shareInstanced];
        
    }
    return self;
    
}

- (instancetype) initWithAPIPath:(NSString *)apiPath{

    self = [self initWithUrl:nil];
    if (self) {
        
        self.apiPath = apiPath;
    }
    
    return self;
}
- (instancetype)init
{
    return [self initWithUrl:@""];
}

- (NSMutableArray<NXUploadFormData *> *) uploadFileArray{

    if (_uploadFileArray == nil) {
        
        _uploadFileArray = [[NSMutableArray alloc] init];
    }
    
    return _uploadFileArray;
}

- (void)setRequstType:(NXNWRequestType)requstType{

    _requstType = requstType;
    if (requstType == NXNWRequestTypeDownload)
    {
        _isBreakpoint = YES;
    }
}

/**
 获取最终生效的请求url, 当baseUrl 和 url同时设置时，根据 ingoreBaseUrl 字段返回url

 @return 请求的url
 */
- (NSString *)url{
    
    if (_url == nil) {
        
        _url = self.config.baseUrl;
    }
    return _url;
}

/**
 获取请求完整的url， url + APiUrl

 @return 拼接的完整url
 */
-(NSString *)fullUrl{

    NSString * baseUrl = self.url;
    if (self.apiPath.length > 0) {
        
        if ([baseUrl hasSuffix:@"/"])
        {
            if ([self.apiPath hasPrefix:@"/"]) {
                NSString * tmpApi = [self.apiPath substringFromIndex:1];
                _fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,tmpApi];
            } else {
            
                _fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,self.apiPath];
            }
            
        } else {
            
            if ([self.apiPath hasPrefix:@"/"]) {
                _fullUrl = [NSString stringWithFormat:@"%@%@",baseUrl,self.apiPath];
            } else {
            _fullUrl = [NSString stringWithFormat:@"%@/%@",baseUrl,self.apiPath];
            }
        }
    } else {
    
        _fullUrl = [NSString stringWithFormat:@"%@",baseUrl];
    }
    return _fullUrl;
}
-(NSString *)uriPath{

    NSMutableString * uri = [[NSMutableString alloc] init];
    NSString  * paramsPath = nil;
    NSString * fullUrl = self.fullUrl;
    NSDictionary * parmaDic = self.params.containerConfigDic;
    if (parmaDic.count > 0) {
     
        __block NSMutableString * tmpParamPath =[[NSMutableString alloc] init];
        [parmaDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [tmpParamPath appendFormat:@"%@=%@&",key,obj];
        }];
        paramsPath = tmpParamPath;
    }
    [uri appendString:fullUrl];
    if (paramsPath.length > 0) {
        paramsPath = [paramsPath substringToIndex:paramsPath.length - 1];
        if (![fullUrl hasSuffix:@"?"]) {
            
            [uri appendString:@"?"];
        }
        [uri appendString:paramsPath];
    }
    
    return uri;
}
/**
 完整的请求头。 返回的 header容器里面已经包含了公共请求头参数

 @return 包含完整请求头信息的容器
 */
- (id<NXContainerProtol>) headers{
    
    if(_headers == nil){
    
        _headers = [[NXContainer alloc] init];
    }

    return _headers;
}

/**
 
 完整的请求参数。返回的params中已经包含设置的公共请求参数
 @return 完整的请求参数容器
 */
- (id<NXContainerProtol>)params{
    
    if (_params == nil) {
        
        _params = [[NXContainer alloc] init];
    }
    return _params;
}

/**
 取消当前请求
 */
- (void)cancelRequset
{
    [[NXNWCerter shareInstanced] cancleRequest:self.identifier];
    
}

/**
 暂停请求
 */
- (void)pauseRequest
{
    [[NXNWCerter shareInstanced] pasueRequest:self.identifier];
}

/**
 恢复请求
 */
- (void)resumeRequst
{
    [[NXNWCerter shareInstanced] resumeRequest:self.identifier request:self];
}

/**
 准备发送请求
 */
- (void)start
{
    [self startWithSucces:self.succesHandlerBlock failure:self.failureHandlerBlock];
}

/**
 准备发送请求

 @param succes 成功回调
 @param failure 失败回调
 */
- (void)startWithSucces:(NXSuccesBlock) succes failure:(NXFailureBlock)failure{

    [self startWithProgress:self.progressHandlerBlock success:succes failure:failure];
    
}

/**
 准备发送请求

 @param progress 进度回调
 @param succes 成功回调
 @param failure 失败回调
 */
- (void)startWithProgress:(NXProgressBlock)progress
          success:(NXSuccesBlock) succes
          failure:(NXFailureBlock)failure{

    [self setProgressHandlerBlock:progress];
    [self setSuccesHandlerBlock:succes];
    [self setFailureHandlerBlock:failure];
    [[NXNWCerter shareInstanced] sendRequset:self];
}


/**
 释放掉当前对象的block，防止循环引用。(该方法在请求成功、失败后会自动调用)
 */
- (void)cleanHandlerBlock
{
    self.progressHandlerBlock = nil;
    self.failureHandlerBlock = nil;
    self.succesHandlerBlock = nil;
    self.requestProcessHandler = nil;
    self.responseProcessHandler = nil;
}

- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData{

    NXUploadFormData * formData =[NXUploadFormData formDataWithName:name fileData:fileData];
    [self.uploadFileArray addObject:formData];
}
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData{

    NXUploadFormData * formData  = [NXUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
    [self.uploadFileArray addObject:formData];
}
- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL{

    NXUploadFormData * formData = [NXUploadFormData formDataWithName:name fileURL:fileURL];
    [self.uploadFileArray addObject:formData];
}
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL{

    NXUploadFormData * formData = [NXUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
    [self.uploadFileArray addObject:formData];
}

- (BOOL)hasRepeatRequest
{
    return [[NXNWCerter shareInstanced] hasRepeatRequest:self];
}

@end

@implementation NXUploadFormData


+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData{

    NXUploadFormData * formData = [[NXUploadFormData alloc] init];
    formData.name = name;
    formData.fileData = fileData;
    return formData;
}
+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL{
    
    NXUploadFormData * formData = [[NXUploadFormData alloc] init];
    formData.name = name;
    formData.fileUrl = fileURL;
    return formData;

}
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData{
    NXUploadFormData * uploadFormData = [[NXUploadFormData alloc] init];
    uploadFormData.name = name;
    uploadFormData.fileName = fileName;
    uploadFormData.mimeType = mimeType;
    uploadFormData.fileData = fileData;
    return uploadFormData;
}
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL{
    NXUploadFormData * uploadFormData = [[NXUploadFormData alloc] init];
    
    uploadFormData.name = name;
    uploadFormData.fileName = fileName;
    uploadFormData.mimeType = mimeType;
    uploadFormData.fileUrl = fileURL;
    return uploadFormData;
}

@end

@interface NXBatchRequest ()

@property(nonatomic,strong) NSLock * lock;
@property(nonatomic,assign) NSInteger finishCount;
@property(nonatomic,assign) BOOL isFailure;
@end


@implementation NXBatchRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.lock = [[NSLock alloc] init];
        self.isFailure = NO;
        self.finishCount = 0;
    }
    return self;
}
- (NSMutableArray *)responsePool{

    if (_requestPool == nil) {
        
        _requestPool = [[NSMutableArray alloc] init];
    }
    
    return _responsePool;
}

- (NSMutableArray<NXNWRequest *> *)requestPool
{
    if (_requestPool == nil) {
        
        _requestPool = [[NSMutableArray alloc] init];
    }
    
    return  _requestPool;
}

- (BOOL)onFinish:(NXNWRequest *)request reposeObject:(id)reposeObject error:(NSError * )error{
    
    [self.lock lock];
    BOOL isFinish = NO;
    NSInteger index = [self.requestPool indexOfObject:request];
    if (reposeObject)
    {
        [self.responsePool replaceObjectAtIndex:index withObject:reposeObject];
    } else {
    
        self.isFailure = YES;
        if (error) {
            
            [self.responsePool replaceObjectAtIndex:index withObject:error];
        }
    }
    self.finishCount +=1;
    NSLog(@"finishCount ===== %ld",(long)self.finishCount);
    if (self.finishCount == self.requestPool.count) {
        
        if (self.isFailure) {
            //整组失败
            if (self.failureBlock) {
                self.failureBlock(self.responsePool);
            }
        } else {
            //整组成功
            if (self.successBlock) {
                self.successBlock(self.responsePool);
            }
        }
        [self cleanHandlerBlock];
        isFinish = YES;
    }
    [self.lock unlock];
    
    return isFinish;
}

- (void)cleanHandlerBlock
{
    self.failureBlock = nil;
    self.successBlock = nil;
    self.bactchRequestBlock =  nil;
}

- (void)startRequset{

    [self startWithSuccess:self.successBlock failure:self.failureBlock];
}

- (void)startWithSuccess:(NXBatchSuccessBlock)success failure:(NXBatchFailureBlock)failure
{
    [self startWithRequest:self.bactchRequestBlock success:success failure:failure];
}
- (void)startWithRequest:(NXAddBatchRequestBlock)bactchRequestBlock success:(NXBatchSuccessBlock) success failure:(NXBatchFailureBlock)failure{

    if (self.requestPool.count <= 0)
    {
        [self addRequests:bactchRequestBlock];
    }
    [[NXNWCerter shareInstanced] sendBatchRequest:self success:success failure:failure];
}
- (void)addRequests:(NXAddBatchRequestBlock)bactchRequestBlock{

    self.bactchRequestBlock = bactchRequestBlock;
    if (bactchRequestBlock)
    {
        bactchRequestBlock(self.requestPool);
    }
}
- (void)cancelRequst{

    for (NXNWRequest * rq in self.requestPool) {
        
        [rq cancelRequset];
    }
}
@end

@interface NXChainRequest ()

@property(nonatomic,strong) id preReposeObj;
@property(nonatomic,assign) BOOL isFirstNode;
@property(nonatomic,assign) BOOL stop;

@property(nonatomic,strong) NSMutableArray * requestPool;
@property(nonatomic,strong) NSMutableArray * responsePool;
@property(nonatomic,assign) NSInteger currenIndex;

@end
@implementation NXChainRequest

- (NSMutableArray *)requestPool{

    if (_requestPool == nil) {
        
        _requestPool = [[NSMutableArray alloc] init];
    }
    
    return _requestPool;
}

- (NSMutableArray *)responsePool{

    if (_responsePool == nil) {
        
        
        _responsePool = [[NSMutableArray alloc] init];
    }
    
    return _responsePool;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirstNode = YES;
        self.stop = NO;
    }
    return self;
}
- (void)buildNodes:(NXChainNodeBuildBlock)buildBlock{

    NSAssert(buildBlock, @"构建链式请求的 buildBlock 不能为空！！！");
    self.buildBlock = nil;
    self.buildBlock = buildBlock;
    if (self.buildBlock) {
        NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:nil];
        self.buildBlock(request, _currenIndex, &_stop, _preReposeObj);
        if (!_stop) {
            [self.requestPool addObject:request];
            [self.responsePool addObject:[NSNull null]];
        }
    }
}

- (BOOL)oneRequestFinish:(NXNWRequest *)request responseObj:(id)responseObj error:(NSError *) error {

    NSAssert((responseObj != nil || error != nil), @"responseObj 和 error 不能同时为空!!!");
    self.isFirstNode = NO;
    BOOL isFinish = NO;
    NSInteger index = [self.requestPool indexOfObject:request];
    if (error) {
        //本次请求失败。直接视为整个请求链表都失败
        isFinish = YES;
        [self.requestPool replaceObjectAtIndex:index withObject:error];
        
        if (self.failureBlock) {
            
            self.failureBlock(self.responsePool);
        }
        [self cleanHandlerBlock];
    } else {
        
        if (responseObj) {
         
            [self.responsePool replaceObjectAtIndex:index withObject:responseObj];
            
        }
        _preReposeObj = responseObj;
        [self buildNodes:self.buildBlock];
        if (self.stop)
        {
            //整条链标志请求完成
            isFinish = YES;
            if (self.succesBlock) {
                
                self.succesBlock(self.responsePool);
            }
            [self cleanHandlerBlock];
        }
    }
    return isFinish;
}

- (void)cleanHandlerBlock
{
    self.succesBlock = nil;
    self.failureBlock = nil;
    self.buildBlock = nil;
}

- (NXNWRequest *)nextRequst
{
    if (self.currenIndex < 0 ||  self.currenIndex >= self.requestPool.count ){
        
        return nil;
    }
    NSInteger index = self.currenIndex ;
    _currenIndex ++;
    return self.requestPool[index];
}
- (void)startRequest
{
    [self startWithSucces:self.succesBlock failure:self.failureBlock];
}
- (void)startWithSucces:(NXChainSuccessBlock)success failure:(NXChainFailureBlock) failure{
    
    [self startWithNodeBuild:self.buildBlock success:success failure:failure];
}
- (void)startWithNodeBuild:(NXChainNodeBuildBlock)nodeBuildBlock success:(NXChainSuccessBlock)success failure:(NXChainFailureBlock) failure{
    if (self.requestPool.count <= 0) {
        
        [self buildNodes:nodeBuildBlock];
    }
    self.succesBlock = success;
    self.failureBlock = failure;
    [[NXNWCerter shareInstanced] sendChainRequst:self];
}

- (void)cancelRequest{

    for (NXNWRequest * rq in self.requestPool) {
        
        [rq cancelRequset];
    }
}

@end
