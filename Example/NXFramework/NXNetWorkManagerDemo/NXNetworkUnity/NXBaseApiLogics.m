//
//  NXBaseApiLogics.m
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXBaseApiLogics.h"

#define CovertReuqest(request) NXRequest * nx_request = (NXRequest *)request;

#define setResponseToRequest(rq,responseObj)  \
                            CovertReuqest(rq) \
                            nx_request.resposeObj =responseObj;

#define setErrorToRequest(rq,error)  \
                    CovertReuqest(rq) \
                    nx_request.error = error;

#define  setProgressToRequest(rq,pro)      \
                        CovertReuqest(rq)   \
                        nx_request.progress = pro;

@implementation NXBaseApiLogics

#pragma mark---消息分发模块
/**
 消息将要分发时候处理逻辑，可以取消当前消息的分发、对数据进行验证、存数据库等操作
 
 @param request 请求request 里面携带服务器返回的 response progress error 信息
 @return 是否分发消息
 */
- (BOOL)willDistributeMsg:(NXRequest *)request
{
    return YES;
}
/**
 消息分发，将当前的request分发给指定代理里面
 @param request
 */
- (void)didDistributeMsg:(NXRequest *) request
{
    if ([self willDistributeMsg:request])
    {
        if (request.error)
        {
            if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(errorRequest:)])
            {
                [self.apiDelegate errorRequest:request];
            }
        }
        else
        {
            if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(finishRequest:)])
            {
                [self.apiDelegate finishRequest:request];
            }
            
        }
    }
}

/**
 分发网络不可达的消息
 @param request 在 NXBaseApiLogics +NXNetWorkUinity 里面验证网络是可达，不可达则不发送请求，并通知上层
 */
- (void)distributeNetWorkNotReachable:(NXRequest *)request
{
    //分发网络不可达消息
    if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(networkNotReachable:)])
    {
        [self.apiDelegate networkNotReachable:request];
    }
}

/**
 上传、下载任务时候进度更新
 */
- (void)distributeProgressDidUpdateMsg:(NXRequest *)request
{
    if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(progressDidUpdate:)])
    {
        [self.apiDelegate progressDidUpdate:request];
    }
}
#pragma mark -- NXNetworkDelegate
- (void)progressDidUpdate:(NXRequest *)request
{
    [self distributeProgressDidUpdateMsg:request];
}

- (void)finishRequest:(NXRequest *)request
{
    [self didDistributeMsg:request];
}

-(void)errorRequest:(NXRequest *)request
{
    [self didDistributeMsg:request];
}

- (void)networkNotReachable:(NXRequest *)request
{
    [self distributeNetWorkNotReachable:request];
}
@end


@implementation NXBaseApiLogics (NXNetWorkUinity)

- (void)sendRequest:(NXRequest *)request
{
    BOOL netWorkReachable = YES;
    if (!netWorkReachable)
    {
        if (request.delegate && [request.delegate respondsToSelector:@selector(networkNotReachable:)])
        {
            [request.delegate networkNotReachable:request];
        }
        return ;
    }
    if (request)
    {
        [request startWithProgress:^(NSProgress *progress){
            
            double pro = progress.fractionCompleted;
            setProgressToRequest(request,pro);
//            [NXBaseApiLogics nx_requestUpdateProgress:nx_request];
        } success:^(id responseObject, NXNWRequest *rq){
            
             setResponseToRequest(rq,responseObject);
//             [NXBaseApiLogics nx_finishRequest:nx_request];
        } failure:^(NSError *error, NXNWRequest *rq) {
            
             setErrorToRequest(rq, error);
//             [NXBaseApiLogics nx_errorRequest:nx_request];
            
         }];
    }
}
#pragma mark
- (void)nx_requestUpdateProgress:(NXRequest *)request
{
    if (request.delegate && [request.delegate respondsToSelector:@selector(progressDidUpdate:)])
    {
        [request.delegate progressDidUpdate:request];
    }
}

- (void)nx_finishRequest:(NXRequest *)request
{
    if (request.delegate && [request.delegate respondsToSelector:@selector(finishRequest:)])
    {
        [request.delegate finishRequest:request];
    }
}

- (void)nx_errorRequest:(NXRequest *)request
{
    if (request.delegate && [request.delegate respondsToSelector:@selector(errorRequest:)])
    {
        [request.delegate errorRequest:request];
    }
}
@end

