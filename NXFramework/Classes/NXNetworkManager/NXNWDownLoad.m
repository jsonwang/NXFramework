//
//  NXNWDownLoad.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/8/10.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNWDownLoad.h"
#import "AFNetworking.h"
#import "NXNWRequest.h"
#import <objc/runtime.h>

//保存缓存文件的目录名 ~/Library/Caches/NXNetWorkDownloadTempFile
#define NXNetWorkDownloadTempFile @"NXNetWorkDownloadTempFile"

//保存URL 和ResumeData文件对应关系 MAP 在 NXNetWorkDownloadTempFile 目录下
#define NXNetWorkDownloadResumeDataMap @"NXNetWorkDownloadResumeDataMap.plist"


@interface NXNWDownLoad ()
{
    NSURLSessionDownloadTask *curDownloadTask;  //当前下载 task
}

@end
@implementation NXNWDownLoad

- (NSURLSessionDownloadTask *)downloadWithRequest:(NXNWRequest *)request
                                         progress:(void (^)(NSProgress *))progressHandler
                                         complete:(NXCompletionHandlerBlock)completionHandler
{
    if (request.url.length == 0)
    {
        NSError *error = [NSError errorWithDomain:@"参数不全" code:-1000 userInfo:nil];
        if (completionHandler)
        {
            completionHandler(self, error, request);
        }

        return nil;
    }

    // 参数
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:request.url]];
    // 目标path
    NSURL * (^destination)(NSURL *, NSURLResponse *) =
        ^NSURL *_Nonnull(NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response)
    {
        return [NSURL fileURLWithPath:request.fileUrl];
    };
    // 1.3 下载完成处理
    MISDownloadManagerCompletion completeBlock = ^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        if (error)
        {
            NSLog(@"下载文件出错:%@", error);
            // 部分网络出错，会返回resumeData 并保存
            NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            [self saveResumeData:resumeData withUrl:response.URL.absoluteString downloadTask:curDownloadTask];
        }
        else
        {
            [self clearDataWithURL:request.url];
        }

        if (completionHandler)
        {
            completionHandler(response, error, request);
        }

    };

    // 1. 生成任务
    NSData *resumeData = [self getResumeDataWithUrl:request.url];
    curDownloadTask = nil;
    if (resumeData)
    {
        // 1.1 有断点信息，走断点下载
        curDownloadTask = [self.manager downloadTaskWithResumeData:resumeData
                                                          progress:progressHandler
                                                       destination:destination
                                                 completionHandler:completeBlock];
    }
    else
    {
        // 1.2 普通下载
        curDownloadTask = [self.manager downloadTaskWithRequest:requestUrl
                                                       progress:progressHandler
                                                    destination:destination
                                              completionHandler:completeBlock];
    }

    return curDownloadTask;
}

// 开始
- (void)startDownloadTask:(NSURLSessionDownloadTask *)task
{
    NSLog(@"开始下载任务");
    [task resume];
}
// 暂停
- (void)suspendDownloadTask:(NSURLSessionDownloadTask *)task
{
    NSLog(@"暂停下载任务");

    [task suspend];
}
// 取消
- (void)cancleDownloadTask:(NSURLSessionDownloadTask *)task
{
    __weak typeof(task) weakTask = task;
    [task cancelByProducingResumeData:^(NSData *_Nullable resumeData) {
        if (self.isBreakpoint)
        {
            [self saveResumeData:resumeData withUrl:weakTask.currentRequest.URL.absoluteString downloadTask:task];
        }

    }];
}

/// 获取临时文件名
- (NSString *)getTempFileNameWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    // NSURLSessionDownloadTask --> 属性downloadFile：__NSCFLocalDownloadFile --> 属性path
    NSString *tempFileName = nil;

    // downloadTask的属性(NSURLSessionDownloadTask) dt
    unsigned int dtpCount;
    objc_property_t *dtps = class_copyPropertyList([downloadTask class], &dtpCount);
    for (int i = 0; i < dtpCount; i++)
    {
        objc_property_t dtp = dtps[i];
        const char *dtpc = property_getName(dtp);
        NSString *dtpName = [NSString stringWithUTF8String:dtpc];

        // downloadFile的属性(__NSCFLocalDownloadFile) df
        if ([dtpName isEqualToString:@"downloadFile"])
        {
            id downloadFile = [downloadTask valueForKey:dtpName];
            unsigned int dfpCount;
            objc_property_t *dfps = class_copyPropertyList([downloadFile class], &dfpCount);
            for (int i = 0; i < dfpCount; i++)
            {
                objc_property_t dfp = dfps[i];
                const char *dfpc = property_getName(dfp);
                NSString *dfpName = [NSString stringWithUTF8String:dfpc];
                // 下载文件的临时地址
                if ([dfpName isEqualToString:@"path"])
                {
                    id pathValue = [downloadFile valueForKey:dfpName];
                    NSString *tempPath = [NSString stringWithFormat:@"%@", pathValue];
                    tempFileName = tempPath.lastPathComponent;
                    break;
                }
            }
            free(dfps);
            break;
        }
    }
    free(dtps);

    return tempFileName;
}

- (NSString *)saveResumeData:(NSData *)resumeData
                     withUrl:(NSString *)url
                downloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    if (resumeData.length < 1 || url.length < 1)
    {
        return nil;
    }

    NSLog(@"保存缓存文件: %@", url);
    // 1.取到 CF 保存的文件名,也可以自己用时间戳创建一个文件名, 用 CF生成的名好查数据对比
    NSString *resumeDataName = [self getTempFileNameWithDownloadTask:downloadTask];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    if (!map)
    {
        map = [NSMutableDictionary dictionary];
    }
    // 删除旧的resumeData
    if (map[url])
    {
        [[NSFileManager defaultManager]
            removeItemAtPath:[[self downloadTempFilePath] stringByAppendingPathComponent:map[url]]
                       error:nil];
    }
    // 更新resumeInfo
    map[url] = resumeDataName;
    [map writeToFile:[self resumeDataMapPath] atomically:YES];

    // 2. 存储resumeData
    NSString *resumeDataPath = [[self downloadTempFilePath] stringByAppendingPathComponent:resumeDataName];

    [resumeData writeToFile:resumeDataPath atomically:YES];

    return resumeDataName;
}

- (NSData *)getResumeDataWithUrl:(NSString *)url
{
    if (url.length < 1)
    {
        return nil;
    }

    // 1. 从map文件中获取resumeData的name
    NSMutableDictionary *resumeMap = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    NSString *resumeDataName = resumeMap[url];

    // 2. 获取data
    NSData *resumeData = nil;
    NSString *resumeDataPath = [[self downloadTempFilePath] stringByAppendingPathComponent:resumeDataName];
    if (resumeDataName.length > 0)
    {
        resumeData = [NSData dataWithContentsOfFile:resumeDataPath];
    }
    NSLog(@"%@: %@", resumeData.length > 0 ? @"查到缓存数据" : @"没有查到缓存数据", url);

    return resumeData;
}

- (void)clearDataWithURL:(NSString *)url
{
    if (url.length < 1)
    {
        return;
    }

    NSString *mapPath = [self resumeDataMapPath];

    NSMutableDictionary *tempFileMap = [NSMutableDictionary dictionaryWithContentsOfFile:mapPath];

    if ([tempFileMap[url] length] > 0)
    {
        [[NSFileManager defaultManager]
            removeItemAtPath:[[self downloadTempFilePath] stringByAppendingPathComponent:tempFileMap[url]]
                       error:nil];

        [tempFileMap removeObjectForKey:url];

        [tempFileMap writeToFile:mapPath atomically:YES];
    }
}
/// 记录resumeData位置的map文件
- (NSString *)resumeDataMapPath
{
    // key: url  value: resumeDataName
    return [[self downloadTempFilePath] stringByAppendingPathComponent:NXNetWorkDownloadResumeDataMap];
}

- (NSString *)downloadTempFilePath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:NXNetWorkDownloadTempFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return path;
}

@end

