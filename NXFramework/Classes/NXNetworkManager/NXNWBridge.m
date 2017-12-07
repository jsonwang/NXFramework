//
//  NXNWBridge.m
//  NXNetworkManager
//
//  Created by 明刘 on 2017/9/10.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNWBridge.h"
#import "AFNetworking.h"
#import "NXNWDownLoad.h"
#import "NXNWRequest.h"
#import "NXNWConfig.h"
#import <objc/runtime.h>
@interface NXNWBridge ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, strong) AFHTTPSessionManager *securitySessionManager;

@property(nonatomic, strong) AFHTTPRequestSerializer *afHTTPRequestSerializer;
@property(nonatomic, strong) AFJSONRequestSerializer *afJSONRequestSerializer;
@property(nonatomic, strong) AFPropertyListRequestSerializer *afPListRequestSerializer;

@property(nonatomic, strong) AFHTTPResponseSerializer *afHTTPResponseSerializer;
@property(nonatomic, strong) AFJSONResponseSerializer *afJSONResponseSerializer;
@property(nonatomic, strong) AFXMLParserResponseSerializer *afXMLResponseSerializer;
@property(nonatomic, strong) AFPropertyListResponseSerializer *afPListResponseSerializer;

@property(nonatomic, strong) NSMutableArray *sslPinningHosts;
@property(nonatomic, strong) NSMutableDictionary *dowloadMapDic;
@property(nonatomic, strong) NSLock *lock;

@end

static OSStatus NXExtractIdentityAndTrustFromPKCS12(CFDataRef inPKCS12Data, CFStringRef keyPassword,
                                                    SecIdentityRef *outIdentity, SecTrustRef *outTrust)
{
    OSStatus securityError = errSecSuccess;

    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {keyPassword};
    CFDictionaryRef optionsDictionary = NULL;

    /* Create a dictionary containing the passphrase if one was specified.
   * Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(NULL, keys, values, (keyPassword ? 1 : 0), NULL, NULL);

    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);

    if (securityError == 0)
    {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;

        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }

    if (optionsDictionary)
    {
        CFRelease(optionsDictionary);
    }

    if (items)
    {
        CFRelease(items);
    }

    return securityError;
}

#pragma mark - NXNWRequest Binding

@implementation NSObject (BindingXMRequest)

static NSString *const NXNWRequestBindingKey = @"NXNWRequestBindingKey";

- (void)bindingRequest:(NXNWRequest *)request
{
    objc_setAssociatedObject(self, (__bridge CFStringRef)NXNWRequestBindingKey, request,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NXNWRequest *)bindedRequest
{
    NXNWRequest *request = objc_getAssociatedObject(self, (__bridge CFStringRef)NXNWRequestBindingKey);
    return request;
}

@end

@implementation NXNWBridge

+ (instancetype)brige { return [[[self class] alloc] init]; }
+ (instancetype)shareInstaced
{
    static NXNWBridge *nx_http_bridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        nx_http_bridge = [[NXNWBridge alloc] init];
    });

    return nx_http_bridge;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.lock = [[NSLock alloc] init];
    }

    return self;
}

- (void)dealloc
{
    if (_sessionManager)
    {
        [_sessionManager invalidateSessionCancelingTasks:YES];
    }

    if (_securitySessionManager)
    {
        [_securitySessionManager invalidateSessionCancelingTasks:YES];
    }
}

- (AFHTTPSessionManager *)sessionManagerWithRequset:(NXNWRequest *)request
{
    if ([self nx_shouldSSLPinningWithURL:request.url])
    {
        return self.securitySessionManager;
    }
    else
    {
        return self.sessionManager;
    }
}

- (AFHTTPResponseSerializer *)resposeSerializerWithRequset:(NXNWRequest *)request
{
    AFHTTPResponseSerializer *responseSerializer = nil;
    switch (request.resopseSerializer)
    {
        case NXHTTResposeSerializerTypeRAW:
        {
            responseSerializer = self.afHTTPResponseSerializer;
        }
        break;
        case NXHTTResposeSerializerTypeXML:
        {
            responseSerializer = self.afXMLResponseSerializer;
        }
        break;
        case NXHTTResposeSerializerTypeJSON:
        {
            responseSerializer = self.afJSONResponseSerializer;
        }
        break;
        case NXHTTResposeSerializerTypePlist:
        {
            responseSerializer = self.afPListResponseSerializer;
        }
        break;
        default:
            break;
    }
    return responseSerializer;
}
- (AFHTTPRequestSerializer *)requestSerializerWithRequest:(NXNWRequest *)requset
{
    AFHTTPRequestSerializer *requsetSirializer = nil;
    switch (requset.requstSerializer)
    {
        case NXHTTPRrequstSerializerTypeRAW:
        {
            requsetSirializer = self.afHTTPRequestSerializer;
        }
        break;
        case NXHTTPRrequstSerializerTypeJSON:
        {
            requsetSirializer = self.afJSONRequestSerializer;
        }
        break;
        case NXHTTPRrequstSerializerTypePlist:
        {
            requsetSirializer = self.afPListRequestSerializer;
        }
        break;
        default:
            break;
    }

    return requsetSirializer;
}
#pragma mark - Accessor

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager)
    {
        _sessionManager = [AFHTTPSessionManager manager];

        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _sessionManager.requestSerializer = self.afHTTPRequestSerializer;
        _sessionManager.responseSerializer = self.afHTTPResponseSerializer;
    }
    _sessionManager.completionQueue = [NXNWConfig shareInstanced].callbackQueue;
    return _sessionManager;
}

- (AFHTTPSessionManager *)securitySessionManager
{
    if (!_securitySessionManager)
    {
        _securitySessionManager = [AFHTTPSessionManager manager];
        _securitySessionManager.requestSerializer = self.afHTTPRequestSerializer;
        _securitySessionManager.responseSerializer = self.afHTTPResponseSerializer;
        _securitySessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        _securitySessionManager.operationQueue.maxConcurrentOperationCount = 5;
    }
    _securitySessionManager.completionQueue = [NXNWConfig shareInstanced].callbackQueue;
    return _securitySessionManager;
}

- (AFHTTPRequestSerializer *)afHTTPRequestSerializer
{
    if (!_afHTTPRequestSerializer)
    {
        _afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _afHTTPRequestSerializer;
}

- (AFJSONRequestSerializer *)afJSONRequestSerializer
{
    if (!_afJSONRequestSerializer)
    {
        _afJSONRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _afJSONRequestSerializer;
}

- (AFPropertyListRequestSerializer *)afPListRequestSerializer
{
    if (!_afPListRequestSerializer)
    {
        _afPListRequestSerializer = [AFPropertyListRequestSerializer serializer];
    }
    return _afPListRequestSerializer;
}

- (AFHTTPResponseSerializer *)afHTTPResponseSerializer
{
    if (!_afHTTPResponseSerializer)
    {
        _afHTTPResponseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _afHTTPResponseSerializer;
}

- (AFJSONResponseSerializer *)afJSONResponseSerializer
{
    if (!_afJSONResponseSerializer)
    {
        _afJSONResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _afJSONResponseSerializer;
}

- (AFXMLParserResponseSerializer *)afXMLResponseSerializer
{
    if (!_afXMLResponseSerializer)
    {
        _afXMLResponseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return _afXMLResponseSerializer;
}

- (AFPropertyListResponseSerializer *)afPListResponseSerializer
{
    if (!_afPListResponseSerializer)
    {
        _afPListResponseSerializer = [AFPropertyListResponseSerializer serializer];
    }
    return _afPListResponseSerializer;
}
- (NSMutableArray *)sslPinningHosts
{
    if (_sslPinningHosts == nil)
    {
        _sslPinningHosts = [[NSMutableArray alloc] init];
    }

    return _sslPinningHosts;
}

- (NSMutableDictionary *)dowloadMapDic
{
    if (_dowloadMapDic == nil)
    {
        _dowloadMapDic = [[NSMutableDictionary alloc] init];
    }
    return _dowloadMapDic;
}
#pragma mark -
- (void)processUrlRequest:(NSMutableURLRequest *)urlRequest withNXNWRequest:(NXNWRequest *)request
{
    NSDictionary *headerDic = [request.headers containerConfigDic];
    if (headerDic.count > 0)
    {
        [headerDic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {

            [urlRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
    urlRequest.timeoutInterval = request.timeOutInterval;
}

- (void)sendWithRequst:(NXNWRequest *)request completionHandler:(NXCompleteBlcok)completionHandler
{
    switch (request.requstType)
    {
        case NXNWRequestTypeNormal:
        {
            [self nx_dataTaskWithRequest:request completionHandler:completionHandler];
        }
        break;
        case NXNWRequestTypeUpload:
        {
            [self nx_uploadTaskWithRequset:request completionHandler:completionHandler];
        }
        break;
        case NXNWRequestTypeDownload:
        {
            [self nx_downloadTastWithRequset:request completionHandler:completionHandler];
        }
        break;
        default:
        {
            NSAssert(NO, @"未知的请求类型");
        }
        break;
    }
}

- (void)nx_dataTaskWithRequest:(NXNWRequest *)requst completionHandler:(NXCompleteBlcok)completionHandler
{
    static NSArray *httpMethodArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpMethodArray = @[ @"GET", @"POST", @"HEAD", @"DELETE", @"PUT", @"PATCH" ];
    });
    NSString *httpMethod;
    if (requst.httpMethod >= 0 && requst.httpMethod < httpMethodArray.count)
    {
        httpMethod = httpMethodArray[requst.httpMethod];
    }

    NSAssert(httpMethod, @"当前 http 请求的类型 requset.httpMethod = %ld", (long)requst.httpMethod);
    AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequset:requst];
    sessionManager.completionQueue = requst.config.callbackQueue;
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequest:requst];
    NSError *urlRequstError;
    NSMutableURLRequest *urlRequst = [requestSerializer requestWithMethod:httpMethod
                                                                URLString:requst.fullUrl
                                                               parameters:requst.params.containerConfigDic
                                                                    error:&urlRequstError];
    urlRequst.cachePolicy = requst.cachePolicy;
    if (urlRequstError)
    {
        if (completionHandler)
        {
            dispatch_async(sessionManager.completionQueue, ^{

                completionHandler(nil, urlRequstError);
            });
        }
        return;
    }

    [self processUrlRequest:urlRequst withNXNWRequest:requst];
    NSURLSessionDataTask *dataTask = nil;
    __weak __typeof(self) weakSelf = self;

    dataTask = [sessionManager
        dataTaskWithRequest:urlRequst
             uploadProgress:nil
           downloadProgress:nil
          completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {

              __strong typeof(weakSelf) strongSelf = weakSelf;
              [strongSelf nx_parseResponse:response
                               responseObj:responseObject
                                     error:error
                                   request:requst
                         completionHandler:completionHandler];
          }];

    [self nx_bindTask:requst dataTaskIdentifier:dataTask sessionManager:sessionManager];
    [dataTask resume];
}

- (void)nx_uploadTaskWithRequset:(NXNWRequest *)request completionHandler:(NXCompleteBlcok)completionHandler
{
    AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequset:request];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithRequest:request];
    __block NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest =
        [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                URLString:request.fullUrl
                                               parameters:request.params.containerConfigDic
                                constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

                                    serializationError = [self bindUploadData:formData request:request];

                                }
                                                    error:&serializationError];

    if (serializationError)
    {
        if (completionHandler)
        {
            dispatch_async(sessionManager.completionQueue, ^{

                completionHandler(nil, serializationError);
            });
        }
        return;
    }

    [self processUrlRequest:urlRequest withNXNWRequest:request];

    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof(self) weakSelf = self;
    uploadTask =
        [sessionManager uploadTaskWithStreamedRequest:urlRequest
                                             progress:request.progressHandlerBlock
                                    completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,
                                                        NSError *_Nullable error) {

                                        __strong typeof(weakSelf) strongSelf = weakSelf;
                                        [strongSelf nx_parseResponse:response
                                                         responseObj:responseObject
                                                               error:error
                                                             request:request
                                                   completionHandler:completionHandler];
                                    }];

    [self nx_bindTask:request dataTaskIdentifier:uploadTask sessionManager:sessionManager];
    [uploadTask resume];
}

- (void)nx_downloadTastWithRequset:(NXNWRequest *)request completionHandler:(NXCompleteBlcok)completionHandler
{
    AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequset:request];
    NXNWDownLoad *downLoad = [[NXNWDownLoad alloc] init];
    downLoad.manager = sessionManager;
    downLoad.isBreakpoint = request.isBreakpoint;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask * downLoadTask = [downLoad downloadWithRequest:request progress:^(NSProgress * progress) {
        if(request.progressHandlerBlock)
        {
            dispatch_async([NXNWConfig shareInstanced].callbackQueue, ^{
               
                request.progressHandlerBlock(progress);
            });
        }
    } complete:^(id responseObject, NSError *error, NXNWRequest *rq) {
        if (completionHandler)
        {
            completionHandler(responseObject, error);
        }
        [weakSelf.dowloadMapDic removeObjectForKey:rq.identifier];
    }];

    [self nx_bindTask:request dataTaskIdentifier:(NSURLSessionDataTask *)downLoadTask sessionManager:sessionManager];
    [self.dowloadMapDic setObject:downLoad forKey:request.identifier];
    [downLoadTask resume];
}
- (void)nx_parseResponse:(NSURLResponse *)response
             responseObj:(id)responseObj
                   error:(NSError *)error
                 request:(NXNWRequest *)request
       completionHandler:(NXCompleteBlcok)completeHandler
{
    NSError *resposeSerializerError;
    if (request.resopseSerializer != NXHTTResposeSerializerTypeRAW)
    {
        AFHTTPResponseSerializer *serializer = [self resposeSerializerWithRequset:request];
        responseObj = [serializer responseObjectForResponse:response data:responseObj error:&resposeSerializerError];
    }

    if (completeHandler)
    {
        if (resposeSerializerError)
        {
            completeHandler(nil, resposeSerializerError);
        }
        else
        {
            completeHandler(responseObj, error);
        }
    }
}
- (void)nx_bindTask:(NXNWRequest *)requset
 dataTaskIdentifier:(NSURLSessionDataTask *)dataTask
     sessionManager:(AFHTTPSessionManager *)sessionManager
{
    NSString *identifier = nil;
    if ([sessionManager isEqual:self.sessionManager])
    {
        identifier = [NSString stringWithFormat:@"+%lu", (unsigned long)dataTask.taskIdentifier];
    }
    else if ([sessionManager isEqual:self.securitySessionManager])
    {
        identifier = [NSString stringWithFormat:@"-%lu", (unsigned long)dataTask.taskIdentifier];
    }
    [requset setValue:identifier forKey:@"_identifier"];
    [dataTask bindingRequest:requset];
}
- (NSError *)bindUploadData:(id<AFMultipartFormData>)formData request:(NXNWRequest *)request
{
    __block NSError *fileError;
    [request.uploadFileArray
        enumerateObjectsUsingBlock:^(NXUploadFormData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

            if (obj.fileData)
            {
                if (obj.fileName && obj.mimeType)
                {
                    [formData appendPartWithFileData:obj.fileData
                                                name:obj.name
                                            fileName:obj.fileName
                                            mimeType:obj.mimeType];
                }
                else
                {
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                }
            }
            else if (obj.fileUrl)
            {
                NSError *fileError = nil;
                if (obj.fileName && obj.mimeType)
                {
                    [formData appendPartWithFileURL:obj.fileUrl
                                               name:obj.name
                                           fileName:obj.fileName
                                           mimeType:obj.mimeType
                                              error:&fileError];
                }
                else
                {
                    [formData appendPartWithFileURL:obj.fileUrl name:obj.name error:&fileError];
                }
                if (fileError)
                {
                    fileError = fileError;
                    *stop = YES;
                }
            }
        }];
    return fileError;
}

- (NXNWRequest *)cancleRequst:(NSString *)identifier
{
    NSURLSessionTask *task = [self getSessionTaskByIdentifer:identifier];
    NXNWRequest *request = nil;
    if (task)
    {
        request = [task bindedRequest];
        if (request.requstType == NXNWRequestTypeDownload)
        {
            NXNWDownLoad *downLoad = [self.dowloadMapDic objectForKey:request.identifier];
            if (downLoad)
            {
                [downLoad cancleDownloadTask:(NSURLSessionDownloadTask *)task];
            }
        }
        else
        {
            if (task.state == NSURLSessionTaskStateRunning)
            {
                [task cancel];
            }
        }
    }

    return request;
}

- (NSURLSessionTask *)getSessionTaskByRequest:(NXNWRequest *)request
{
    if (!request)
    {
        return nil;
    }
    [self.lock lock];
    NSString *url = [request uriPath];
    NSArray *tasks = nil;
    if ([url hasPrefix:@"http://"])
    {
        tasks = self.sessionManager.tasks;
    }
    if ([url hasPrefix:@"https://"])
    {
        tasks = self.securitySessionManager.tasks;
    }
    NSURLSessionTask *sessionTask = nil;
    if (tasks.count > 0)
    {
        for (NSURLSessionTask *task in tasks)
        {
            NXNWRequest *bindRequest = [task bindedRequest];
            NSString *bindUri = [bindRequest uriPath];
            if ([url isEqualToString:bindUri] && (request.httpMethod == bindRequest.httpMethod))
            {
                sessionTask = task;
            }
        }
    }
    [self.lock unlock];
    return sessionTask;
}

- (NSURLSessionTask *)getSessionTaskByIdentifer:(NSString *)identifier
{
    if (identifier.length <= 0)
    {
        return nil;
    }
    [self.lock lock];

    NSArray *tasks = nil;
    if ([identifier hasPrefix:@"+"])
    {
        tasks = self.sessionManager.tasks;
    }
    else if ([identifier hasPrefix:@"-"])
    {
        tasks = self.securitySessionManager.tasks;
    }
    NSURLSessionTask *sessionTask = nil;
    if (tasks.count > 0)
    {
        for (NSURLSessionTask *task in tasks)
        {
            if ([task.bindedRequest.identifier isEqualToString:identifier])
            {
                sessionTask = task;
                break;
            }
        }
    }
    [self.lock unlock];

    return sessionTask;
}
- (NXNWRequest *)getRequestByIdentifier:(NSString *)identifier
{
    NSURLSessionTask *task = [self getSessionTaskByIdentifer:identifier];
    NXNWRequest *request = nil;
    if (task)
    {
        request = [task bindedRequest];
    }

    return request;
}

- (void)pauseRequest:(NSString *)identifier
{
    NSURLSessionTask *task = [self getSessionTaskByIdentifer:identifier];
    if (task)
    {
        NXNWRequest *request = [task bindedRequest];
        if (request.requstType == NXNWRequestTypeDownload)
        {
            NXNWDownLoad *downLoad = [self.dowloadMapDic objectForKey:request.identifier];
            if (downLoad)
            {
                [downLoad suspendDownloadTask:(NSURLSessionDownloadTask *)task];
            }
        }
        else
        {
            [task suspend];
        }
    }
}
- (void)resumeRequest:(NSString *)identifier
{
    NSURLSessionTask *task = [self getSessionTaskByIdentifer:identifier];
    if (task)
    {
        NXNWRequest *request = [task bindedRequest];
        if (request.requstType == NXNWRequestTypeDownload)
        {
            NXNWDownLoad *downLoad = [self.dowloadMapDic objectForKey:request.identifier];
            if (downLoad)
            {
                [downLoad startDownloadTask:(NSURLSessionDownloadTask *)task];
            }
        }
        else
        {
            [task resume];
        }
    }
}

- (void)addSSLPinningURL:(NSString *)url
{
    if ([url hasPrefix:@"https"])
    {
        NSString *rootDamainName = [self nx_rootDomainNameFromURL:url];
        if (rootDamainName && ![self.sslPinningHosts containsObject:rootDamainName])
        {
            [self.sslPinningHosts addObject:rootDamainName];
        }
    }
}

- (void)addSSLPinningCert:(NSData *)cert
{
    NSAssert(cert, @"cert can not nil");
    NSMutableSet *certSet;
    if (self.securitySessionManager.securityPolicy.pinnedCertificates.count > 0)
    {
        certSet = [NSMutableSet setWithSet:self.securitySessionManager.securityPolicy.pinnedCertificates];
    }
    else
    {
        certSet = [NSMutableSet set];
    }
    [certSet addObject:cert];
    [self.securitySessionManager.securityPolicy setPinnedCertificates:certSet];
}

- (void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password
{
    NSParameterAssert(p12);
    NSParameterAssert(password);
    __weak __typeof(self) weakSelf = self;
    [self.securitySessionManager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(
                                     NSURLSession *_Nonnull session, NSURLAuthenticationChallenge *_Nonnull challenge,
                                     NSURLCredential *__autoreleasing _Nullable *_Nullable credential) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        {
            // Server Trust (SSL Pinning)
            if ([strongSelf.securitySessionManager.securityPolicy
                    evaluateServerTrust:challenge.protectionSpace.serverTrust
                              forDomain:challenge.protectionSpace.host])
            {
                *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (*credential)
                {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
                else
                {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            }
            else
            {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
        else if ([challenge.protectionSpace.authenticationMethod
                     isEqualToString:NSURLAuthenticationMethodClientCertificate])
        {
            // Client Certificate (Two-way Authentication)
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;

            if (NXExtractIdentityAndTrustFromPKCS12((__bridge CFDataRef)p12, (__bridge CFStringRef)password, &identity,
                                                    &trust) == 0)
            {
                SecCertificateRef certificate = NULL;
                SecIdentityCopyCertificate(identity, &certificate);

                const void *certs[] = {certificate};
                CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
                *credential = [NSURLCredential credentialWithIdentity:identity
                                                         certificates:(__bridge NSArray *)certArray
                                                          persistence:NSURLCredentialPersistencePermanent];
                if (*credential)
                {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
                else
                {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }

                if (certificate)
                {
                    CFRelease(certificate);
                }
                if (certArray)
                {
                    CFRelease(certArray);
                }
            }

            if (identity)
            {
                CFRelease(identity);
            }
            if (trust)
            {
                CFRelease(trust);
            }
        }
        else
        {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }

        return disposition;
    }];
}

- (NSString *)nx_rootDomainNameFromURL:(NSString *)urlString
{
    NSString *host = [[NSURL URLWithString:urlString] host];
    NSArray *hostComponents = [host componentsSeparatedByString:@"."];
    if ([hostComponents count] >= 2)
    {
        host = [NSString stringWithFormat:@"%@.%@", [hostComponents objectAtIndex:(hostComponents.count - 2)],
                                          [hostComponents objectAtIndex:(hostComponents.count - 1)]];
    }
    return host;
}
- (BOOL)nx_shouldSSLPinningWithURL:(NSString *)urlString
{
    if (urlString && [urlString hasPrefix:@"https"])
    {
        NSString *rootDomainName = [self nx_rootDomainNameFromURL:urlString];
        if ([self.sslPinningHosts containsObject:rootDomainName])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasRepeatRequest:(NXNWRequest *)request { return ([self getSessionTaskByRequest:request] != nil); }
@end
