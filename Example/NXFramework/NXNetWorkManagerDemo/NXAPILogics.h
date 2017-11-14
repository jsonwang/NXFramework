//
//  NXAPILogics.h
//  NXFramework
//
//  Created by liuming on 2017/10/26.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXHttpCmd.h"
@class NXAPILogics;
@protocol NXAPILogicsDelegate <NSObject>

- (void)httpRequestSuccess:(NXAPILogics *)apiLogics;
- (void)httpRequstFailure:(NXAPILogics *)apiLogics;
- (void)httpRequsetProgress:(NXAPILogics *)apiLogics;

@end
@interface NXAPILogics : NSObject

/**
    当前对象的标记。用于一个页面有多个请求时,给不同的请求打上tag。在得到回调时，用该tag区分不同的请求
 */
@property(nonatomic,copy) NSString * tag;

/**
 http 请求返回的结果.经过序列化
 */
@property(nonatomic,strong,readonly) id responseObj;

/**
 请求出错的error 信息
 */
@property(nonatomic,strong,readonly) NSError * error;

/**
 执行上传或者下载任务的进度
 */
@property(nonatomic,strong)NSProgress * progress;


/**
 回调代理。当代理和通知同时存在的时候 优先使用代理
 */
@property(nonatomic,weak) id<NXAPILogicsDelegate> delegate;

/**
 向请求通知池子中注测本次请求过程中 请求回调的通知key

 @param successKey 成功回调 发送的通知key
 @param failureKey 失败回调 发送的通知key
 @param progressKey 进度回调 发送的通知key
 */
- (void)regisertNotiSuccessKey:(NSString *)successKey failureKey:(NSString *)failureKey progressKey:(NSString *) progressKey;
/**
 开始请求
 */
- (void)start;

/**
 开始请求 带了进度回调
 */
- (void)startWithProgress;

/**
 恢复已经暂停的请求
 */
- (void)resume;
/**
 取消请求
 */
- (void)cancel;

/**
 暂停请求
 */
- (void)pause;


#pragma mark 子类重写设置方法
/**
  请求的url。 默认使用config配置的baseURL，当不实用config配置的baseURL需要重写该方法
 @return baseUrl
 */
- (NSString *)baseUrl;

/**
 请求的API路径。子类必须重写 例如@"/user/Login"

 @return apiPath
 */
- (NSString *)requestAPIPath;

/**
 超时时间。默认十秒

 @return 超时时间
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 HTTP 请求方法 默认 GET
 @return
 */
- (NXHTTPMethodType)requestMethod;

/**
 Response 序列化类型 默认序列化成json

 @return
 */
- (NXResposeSerializerType)responseSerializerType;

/**
 请求的参数，除了公共配置中所配置的参数
 @param params 参数容器
 */
- (void)requestParams:(id<NXContainerProtol>)params;

/**
 往 http头中添加的参数。
 @param headers
 */
- (void)requestHeaders:(id<NXContainerProtol>)headers;

/**
 构建一个自定义的request对象。子类需要设定除了上述方法公开的配置 
 如 ingoreDefaultHttpHeaders、requstType等属性时可以实现该方法，将额外需要设置的的属性赋值。
 */
- (NXNWRequest *)buildCustomRequest;

@end


