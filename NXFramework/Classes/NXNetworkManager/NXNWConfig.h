//
//  NXNWConfig.h
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/7.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXNWConstant.h"
@interface NXNWConfig : NSObject

+ (instancetype)shareInstanced;
/**
 请求的baseUrl
 */
@property(nonatomic,strong) NSString *baseUrl;

/**
 https证书路径
 */
@property(nonatomic,strong)NSString * cerPath;


/**
 是否输出调试log
 */
@property (nonatomic, assign) BOOL consoleLog;


/**
 请求返回后的回调队列 默认主线程队列
 */
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

/**
 公共请求参数容器
 */
@property(nonatomic,strong)id<NXContainerProtol>globalParams;

/**
 公共请求头容器
 */
@property(nonatomic,strong)id<NXContainerProtol>globalHeaders;



- (void)addSSLPinningURL:(NSString *)url;
- (void)addSSLPinningCert:(NSData *)cert;
- (void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password;
@end


@interface NXContainer : NSObject<NXContainerProtol>

@end
