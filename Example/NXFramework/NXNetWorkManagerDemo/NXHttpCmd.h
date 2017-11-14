//
//  NXHttpcmd.h
//  NXFramework
//
//  Created by liuming on 2017/10/26.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXHttpCmd : NSObject

- (instancetype) initWithBaseUrl:(NSString *)baseUrl;
- (instancetype) initWithWithApiPath:(NSString *)apiPath;

/**
 请求url，当url有值且全局配置的BaseUrl也有值 并且ingoreBaseUrl为NO的情况下
 以全局配置的url为准
 */
@property(nonatomic, strong) NSString *url;


/**
  接口 APIPath  例如 @"/user/login"
 */
@property(nonatomic,strong)NSString * apiPath;

/**
 当前请求的任务类型  NXNWRequestTypeNormal、NXNWRequestTypeUpload、NXNWRequestTypeDownload
 
 默认是 NXNWRequestTypeNormal (get post put delete...),执行上传和下载任务时候需要单独设置
 */
@property(nonatomic,assign) NXNWRequestType requestType;

/**
 NXHTTPMethodTypeOfGET,     // get请求
 NXHTTPMethodTypeOfPOST,    // post请求
 NXHTTPMethodTypeOfHEAD,    // head
 NXHTTPMethodTypeOfDELETE,  // delete
 NXHTTPMethodTypeOfPUT,     // put
 NXHTTPMethodTypeOfPATCH,   // patch
 
 当前请求的 httpMethod  默认为 NXHTTPMethodTypeOfGET
 */
@property(nonatomic,assign) NXHTTPMethodType method;

/**
 NXHTTResposeSerializerTypeRAW,    ///<*
 NXHTTResposeSerializerTypeJSON,   ///<* json
 NXHTTResposeSerializerTypePlist,  ///<* plist
 NXHTTResposeSerializerTypeXML,    ///<* xml
 
 请求返回的参数序列化格式 默认使用 NXHTTResposeSerializerTypeJSON
 */
@property(nonatomic,assign) NXResposeSerializerType resposeSerializerType;

/**
 当前对象的标记。用于一个页面有多个请求时,给不同的请求打上tag。在得到回调时，用该tag区分不同的请求
 */
@property(nonatomic,copy) NSString * tag;

/**
 超时时间
 */
@property(nonatomic, assign) NSTimeInterval timeOutInterval;

/**
 本次请求是否忽略默认配置的httpHeader  默认为NO 不忽略
 */
@property(nonatomic, assign) BOOL ingoreDefaultHttpHeaders;

/**
 本次请求是否忽略默认配置的请求参数 默认为NO 不忽略
 */
@property(nonatomic, assign) BOOL ingoreDefaultHttpParams;

/**
 上传 或者 下载文件存放的路径
 */
@property(nonatomic, strong) NSString *fileUrl;

/**
 http 请求参数信息
 */
@property(nonatomic, strong) id<NXContainerProtol> params;

/**
 http 请求头信息
 */
@property(nonatomic, strong) id<NXContainerProtol> headers;

/**
 缓存策略 默认 NSURLRequestUseProtocolCachePolicy；
 */
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
 请求的类型，默认 NXNWRequestTypeNormal(包含 get、post...)
 */
@property(nonatomic, assign) NXNWRequestType requstType;

/**
 是否支持断点下载 默认值为YES支持
 */
@property(nonatomic, assign) BOOL isBreakpoint;

/**
 请求方法 GET POST
 */
@property(nonatomic, assign) NXHTTPMethodType httpMethod;

/**
 requst content-type, 默认 NXHTTPRrequstSerializerTypeJSON
 */
@property(nonatomic, assign) NXRequstSerializerType requstSerializer;

/**
 resposObj 响应对象序列化样式 json、xml、plist、raw。 默认序列化成json
 */
@property(nonatomic, assign) NXResposeSerializerType resopseSerializer;

/**
 是否允许同一个url重复请求. 默认为NO
 */
@property(nonatomic, assign) BOOL allowRepeatHttpRequest;

/**
 重试次数 默认不重试
 */
@property(nonatomic, assign) NSInteger retryCount;


@end
