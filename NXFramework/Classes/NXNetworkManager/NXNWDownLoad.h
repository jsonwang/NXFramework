//
//  NXNWDownLoad.h
//  NXNetworkManager
//
//  Created by yoyo on 2017/8/10.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXNWConstant.h"
@class AFHTTPSessionManager;
@interface NXNWDownLoad : NSObject

typedef void(^MISDownloadManagerCompletion)(NSURLResponse *response, NSURL *filePath, NSError *error);


/**
 下载的session
 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;


/**
  是否支持断点下载 默认值为YES支持
 */
@property (nonatomic,assign) BOOL isBreakpoint;

- (NSURLSessionDownloadTask *)downloadWithRequest:(NXNWRequest *)request
                                         progress:(void (^)(NSProgress *))progressHandler
                                         complete:(NXCompletionHandlerBlock)completionHandler;


// 开始
- (void)startDownloadTask:(NSURLSessionDownloadTask *)task;

// 暂停
- (void)suspendDownloadTask:(NSURLSessionDownloadTask *)task;

// 取消
- (void)cancleDownloadTask:(NSURLSessionDownloadTask *)task;

@end
