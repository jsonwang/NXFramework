//
//  NXRequest.h
//  NXFramework_Example
//
//  Created by liuming on 2017/12/21.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import <NXFramework/NXFramework.h>
@class NXBaseApiLogics;
@class NXRequest;
@protocol NXNetworkDelegate<NSObject>

/**
 进度更新回调
 */
- (void)progressDidUpdate:(NXRequest *)request;

/**
 请求完成回调
 */
- (void)finishRequest:(NXRequest *)request;

/**
 出错回调
 */
- (void)errorRequest:(NXRequest *)request;

/**
 网络不可达回调
 */
- (void)networkNotReachable:(NXRequest *)request;


@end
@interface NXRequest : NXNWRequest

@property(nonatomic,weak)NXBaseApiLogics<NXNetworkDelegate>* delegate;

@property(nonatomic,assign) NSInteger msgId;

@property(nonatomic,assign) NSInteger tag;

@property(nonatomic,strong)id resposeObj;
@property(nonatomic,assign)double progress;
@property(nonatomic,strong)NSError * error;

@end
