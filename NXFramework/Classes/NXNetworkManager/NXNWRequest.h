//
//  NXNWRequest.h
//  NXNetworkManager
//
//  Created by yoyo on 2017/8/10.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXNWConstant.h"

@class NXNWConfig;
@class NXUploadFormData;
/**
 Http requset
 */
@interface NXNWRequest : NSObject

- (instancetype) initWithUrl:(NSString * )url;
- (instancetype) initWithAPIPath:(NSString *)apiPath;
/**
 请求url，当url有值且全局配置的BaseUrl也有值 并且ingoreBaseUrl为NO的情况下 以全局配置的url为准
 */
@property(nonatomic,strong)NSString * url;
/**
 接口路径
 */
@property(nonatomic,strong)NSString * apiPath;

/**
 接口完整路径 baseUrl + api
 */
@property(nonatomic,strong,readonly)NSString * fullUrl;


/**
 完整的请求Url baseUrl + api + params
 */
@property(nonatomic,strong,readonly)NSString * uriPath;
/**
 超时时间
 */
@property(nonatomic,assign) NSTimeInterval timeOutInterval;

/**
 是否忽略全局配置中的 baseUrl。默认NO 不忽略
 */
//@property(nonatomic,assign)BOOL ingoreBaseUrl;

/**
 本次请求是否忽略默认配置的httpHeader  默认为NO 不忽略
 */
@property(nonatomic,assign) BOOL ingoreDefaultHttpHeaders;

/**
 本次请求是否忽略默认配置的请求参数 默认为NO 不忽略
 */
@property(nonatomic,assign) BOOL ingoreDefaultHttpParams;
/**
 上传 或者 下载文件存放的路径
 */
@property(nonatomic,strong) NSString * fileUrl;
/**
 http 请求参数信息
 */
@property(nonatomic,strong)id<NXContainerProtol> params;

/**
 http 请求头信息
 */
@property(nonatomic,strong)id<NXContainerProtol> headers;


/**
 requset请求的全局配置信息。 携带公共请求头、请求参数、baseUrl
 */
@property(nonatomic,strong)NXNWConfig  *config;


/**
 缓存策略 默认 NSURLRequestUseProtocolCachePolicy；
 */
@property(nonatomic,assign) NSURLRequestCachePolicy  cachePolicy;

/**
 请求ID
 */
@property(nonatomic,strong)NSString * identifier;


/**
 请求的类型，默认 NXNWRequestTypeNormal(包含 get、post...)
 */
@property(nonatomic,assign)NXNWRequestType  requstType;

/**
 是否支持断点下载 默认值为YES支持
 */
@property (nonatomic,assign) BOOL isBreakpoint;

/**
 请求方法 GET POST
 */
@property(nonatomic,assign) NXHTTPMethodType httpMethod;

/**
 requst content-type, 默认 NXHTTPRrequstSerializerTypeJSON
 */
@property(nonatomic,assign) NXRequstSerializerType  requstSerializer;

/**
 resposObj 响应对象序列化样式 json、xml、plist、raw。 默认序列化成json
 */
@property(nonatomic,assign) NXResposeSerializerType resopseSerializer;
/**
 请求失败回调方法
 */
@property(nonatomic,copy) NXFailureBlock  failureHandlerBlock;

/**
  请求成功回调
 */
@property(nonatomic,copy) NXSuccesBlock   succesHandlerBlock;

/**
 进度回调
 */
@property(nonatomic,copy) NXProgressBlock progressHandlerBlock;

/**
 发起请求之前执行此回调
 */
@property(nonatomic,copy) NXNWRequestProcessBlock requestProcessHandler;

/**
 接受到请求数据,调用succesHandlerBlock之前执行此回调
 */
@property(nonatomic,copy) NXResponseProcessBlcok responseProcessHandler;

/**
 重试次数 默认不重试
 */
@property(nonatomic,assign) NSInteger retryCount;

/**
 上传文件数组
 */
@property(nonatomic,strong)NSMutableArray <NXUploadFormData *> * uploadFileArray;

/**
 是否允许同一个url重复请求. 默认为NO
 */
@property(nonatomic,assign)BOOL allowRepeatHttpRequest;

/**
 开始发起请求
 @param progress 进度block
 @param succes 成功回调block
 @param failure 失败回调
 */
- (void)startWithProgress:(NXProgressBlock)progress success:(NXSuccesBlock) succes failure:(NXFailureBlock)failure;


/**
 开始发起请求

 @param succes 成功回调
 @param failure 失败回调
 */
- (void)startWithSucces:(NXSuccesBlock) succes failure:(NXFailureBlock)failure;
/**
 开始发起请求
 */
- (void)start;

/**
 取消当前请求
 */
- (void)cancelRequset;

/**
 
 */
- (void)pauseRequest;
- (void)resumeRequst;

/**
 清空当前对象的所有回调 避免block循环引用
 */
- (void)cleanHandlerBlock;

/**
 查找当前请求 在队里中是否已经存在
 */
- (BOOL)hasRepeatRequest;

#pragma mark -上传文件
- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData;

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;

@end

/**
  上传时 填充表单的文件数据类
 */
@interface NXUploadFormData : NSObject

/**
 上传文件 name (具体做什么的?)
 */
@property(nonatomic,copy)   NSString * name;

/**
 上传文件的 filename 写入http header中 Content-Disposition字段
 */
@property(nonatomic,copy)   NSString * fileName;

/**
 上传文件的 mimeType
 */
@property(nonatomic,copy)   NSString * mimeType;

/**
 上传文件数据
 */
@property(nonatomic,strong) NSData * fileData;

/**
 上传文件 url
 */
@property(nonatomic,strong) NSURL * fileUrl;

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;
@end

@interface NXBatchRequest : NSObject

/**
 本次批量请求的 identifier
 */
@property(nonatomic,strong)NSString * identifier;

/**
 request请求池
 */
@property(nonatomic,strong)NSMutableArray<NXNWRequest *> * requestPool;

/**
 响应数据池子
 */
@property(nonatomic,strong)NSMutableArray * responsePool;

/**
 失败回调 ---> 一个请求失败了 整组就视为失败
 */
@property(nonatomic,copy)NXBatchFailureBlock  failureBlock;

/**
 成功回调
 */
@property(nonatomic,copy)NXBatchSuccessBlock  successBlock;

@property(nonatomic,copy)NXAddBatchRequestBlock bactchRequestBlock;

- (BOOL)onFinish:(NXNWRequest *)request reposeObject:(id)reposeObject error:(NSError * )error;

- (void)startRequset;
- (void)startWithSuccess:(NXBatchSuccessBlock) success failure:(NXBatchFailureBlock)failure;
- (void)startWithRequest:(NXAddBatchRequestBlock)bactchRequestBlock success:(NXBatchSuccessBlock) success failure:(NXBatchFailureBlock)failure;

- (void)addRequests:(NXAddBatchRequestBlock)bactchRequestBlock;
/**
 清空当前对象的所有回调 避免block循环引用
 */
- (void)cleanHandlerBlock;

- (void)cancelRequst;
@end

@interface NXChainRequest : NSObject

/**
 本次链接请求的 identifier 唯一标识
 */
@property(nonatomic,strong)NSString * identifier;

/**
 请求失败回调 ---> 链式请求中有一个失败则视为整体失败
 */
@property(nonatomic,copy)NXChainFailureBlock failureBlock;

/**
 请求成功回调
 */
@property(nonatomic,copy)NXChainSuccessBlock succesBlock;

/**
 构建链式请求节点回调
 */
@property(nonatomic,copy)NXChainNodeBuildBlock buildBlock;

/**
 清空当前对象的所有回调 避免block循环引用
 */
- (void)cleanHandlerBlock;

- (BOOL)oneRequestFinish:(NXNWRequest *)request responseObj:(id)responseObj error:(NSError *) error;

/**
 获取链表下一个request

 @return  下一个request
 */
- (NXNWRequest *)nextRequst;

/**
 发起链式请求
 */
- (void)startRequest;

/**
 
 发起链式请求
 @param success 全部成功之后的回调
 @param failure 失败回调。 (一个请求失败则视为整条链失败)
 */
- (void)startWithSucces:(NXChainSuccessBlock)success failure:(NXChainFailureBlock) failure;

/**
 发起链式请求

 @param nodeBuildBlock 构建链式request block
 @param success 全部成功之后的回调
 @param failure 失败回调。 (一个请求失败则视为整条链失败)
 */
- (void)startWithNodeBuild:(NXChainNodeBuildBlock)nodeBuildBlock success:(NXChainSuccessBlock)success failure:(NXChainFailureBlock) failure;


/**
 取消请求
 */
- (void)cancelRequest;

@end
