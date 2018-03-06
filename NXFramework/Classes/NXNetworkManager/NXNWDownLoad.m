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

#define NXNetWorkDownloadFileTotalLengthMap @"NXNetWorkDownloadFileTotalLengthMap.plist"

static dispatch_queue_t  fileIOQueue ;

@interface NXNWDownLoad ()
{
    
}

@property(nonatomic,strong) NSURLSessionDownloadTask *curDownloadTask;  //当前下载 task
@property(nonatomic,assign) uint64_t currentFileTotalLength;            //当前下载文件的总长度
@end
@implementation NXNWDownLoad

- (instancetype) init{
    
    self = [super init];
    if (self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if(fileIOQueue == nil)
            {
                fileIOQueue = dispatch_queue_create("NXFileIOQueue", DISPATCH_QUEUE_CONCURRENT);
            }
        });
    }
    return  self;
    
}
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
    self.currentFileTotalLength = [self getFileTotalLengthFromCatch:request.uriPath];
    // 参数
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:request.uriPath]];
    // 目标path
    NSURL * (^destination)(NSURL *, NSURLResponse *) =
    ^NSURL *_Nonnull(NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response)
    {
        return [NSURL fileURLWithPath:request.fileUrl];
    };
    __weak typeof(self)weakSelf = self;
    // 1.3 下载完成处理
    MISDownloadManagerCompletion completeBlock = ^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf)
        {
            if (error)
            {
                NSLog(@"下载文件出错:%@", error);
                // 部分网络出错，会返回resumeData 并保存
                NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
                [strongSelf saveResumeData:resumeData withUrl:response.URL.absoluteString downloadTask:strongSelf.curDownloadTask];
            }
            else
            {
                [strongSelf clearDataWithURL:response.URL.absoluteString];
                [strongSelf removeFileTotalLengthCache:request.uriPath];
            }
            
            if (completionHandler)
            {
                completionHandler(response, error, request);
            }
            
        }
    };
    NXProgressBlock progressBlock= ^(NSProgress * downloadProgress){
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf)
        {
            if(strongSelf.currentFileTotalLength < downloadProgress.totalUnitCount)
            {
                strongSelf.currentFileTotalLength = downloadProgress.totalUnitCount;
                [strongSelf cacheCurrenFileWithUrl:request.uriPath length:self.currentFileTotalLength];
            }
            if(progressHandler)
            {
                downloadProgress.totalUnitCount = strongSelf.currentFileTotalLength;
                progressHandler(downloadProgress);
            }
        }
    };
    // 1. 生成任务
    NSData *resumeData = [self getResumeDataWithUrl:request.uriPath];
    self.curDownloadTask = nil;
    if (resumeData)
    {
        // 1.1 有断点信息，走断点下载
        self.curDownloadTask = [self.manager downloadTaskWithResumeData:resumeData
                                                               progress:progressBlock
                                                            destination:destination
                                                      completionHandler:completeBlock];
    }
    else
    {
        // 1.2 普通下载
        self.curDownloadTask = [self.manager downloadTaskWithRequest:requestUrl
                                                            progress:progressBlock
                                                         destination:destination
                                                   completionHandler:completeBlock];
    }
    
    return self.curDownloadTask;
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
    // NSURLSessionDownloadTask --> 属性downloadFile：__NSCFLocalDownloadFile -->
    // 属性path
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
    // 1.取到 CF 保存的文件名,也可以自己用时间戳创建一个文件名, 用
    // CF生成的名好查数据对比
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
- (NSString *)fileTotalLengthMapPath
{
    return [[self downloadTempFilePath] stringByAppendingPathComponent:NXNetWorkDownloadFileTotalLengthMap];
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

#pragma mark 文件总长度缓存
- (void)cacheCurrenFileWithUrl:(NSString *)url length:(uint64_t)length
{
    if(url <= 0 || url == nil){
        NSLog(@"cacheCurrenFileWithUrl url is ni");
        return ;
    }
    NSLog(@"缓存总长度文件缓存文件: %@   文件大小 %llud", url,length);
    NSMutableDictionary * totalLengthMap = [self getFileTotalCacheDic];
    if(!totalLengthMap[url] || [totalLengthMap[url] unsignedLongLongValue] < length)
    {
        totalLengthMap[url] = @(length);
        [self writeCacheDicToFile:totalLengthMap];
    }
}
- (void)removeFileTotalLengthCache:(NSString *)url
{
    NSMutableDictionary * totalLengthMap = [self getFileTotalCacheDic];
    if(totalLengthMap[url])
    {
        [totalLengthMap removeObjectForKey:url];
        [self writeCacheDicToFile:totalLengthMap];
    }
}
- (uint64_t)getFileTotalLengthFromCatch:(NSString *)url
{
    if(url.length <= 0)
    {
        NSLog(@" getFileTotalLengthFromCatch url is ni");
        return 0;
    }
    NSMutableDictionary * fileLengthCacheMap = [self getFileTotalCacheDic];
    return [fileLengthCacheMap[url] unsignedLongLongValue];
}
- (void)writeCacheDicToFile:(NSMutableDictionary *)cacheDic
{
    dispatch_barrier_async(fileIOQueue, ^{
        if(!cacheDic)
        {
            NSLog(@"缓存字典为空");
            return ;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self fileTotalLengthMapPath]])
        {
            [[NSFileManager defaultManager] removeItemAtPath:[self fileTotalLengthMapPath] error:nil];
        }
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:cacheDic options:NSJSONWritingPrettyPrinted error:&error];
        if(!error)
        {
            BOOL result = [[NSFileManager defaultManager] createFileAtPath:[self fileTotalLengthMapPath] contents:data attributes:nil];
            if (!result)
            {
                NSLog(@"写入文件失败");
            }
        }
    });
}
- (NSMutableDictionary *)getFileTotalCacheDic
{
    
    __block  NSMutableDictionary * totalLengthMap = [[NSMutableDictionary alloc] init];
    dispatch_sync(fileIOQueue, ^{
        
        if([[NSFileManager defaultManager] fileExistsAtPath:[self fileTotalLengthMapPath]])
        {
            NSData * data =[[NSFileManager defaultManager] contentsAtPath:[self fileTotalLengthMapPath]];
            
            NSError * error = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error)
            {
                NSLog(@"error  = %@",[error userInfo]);
            }
            totalLengthMap = [[NSMutableDictionary alloc] initWithDictionary:obj];
            
        } else {
            
            NSLog(@"%@  文件不存在",[self fileTotalLengthMapPath]);
        }
    });
    return totalLengthMap;
}
@end

