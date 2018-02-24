## 功能
-----
* 发送请求方法为GET，POST，PUT，DELETE的普通网络请求的功能
* 上传图片功能（单张与多张上传，指定上传前的图片压缩比率）
* 下载功能（支持断点续传和后台下载）
* 添加请求头
* 设置服务器地址
* 批量请求
* 链式请求


| 类名       | 职责     |  
| --------   |:-----   |
| NXNetWorkManagerHeader | 总头文件，只需要引入该文件即可使用该框架所有功能      |
| NXNWConstant        |定制了NXNetworkManager中的所有的 枚举、协议、block ,今后可能还会扩展   |
| NXNWConfig        | 公共参数配置类    |
|NXNWRequest        | 请求对象类：使用该类可以配置HttpMothed、超时时间、系统缓存策略、重试次数、请求结果序列化类型、请求头、请求参数、请求优先级 、|
|NXBatchRequest|批量请求类(基于NXNWRequest)，当批量请求中一个请求失败了，则视为整租失败|
|NXChainRequest | 链式请求(基于NXNWRequest),当链式请求中的一个请求失败，则视为整组失败|
|NXUploadFormData| 上传文件数据载体类|
|NXNWCerter|请求发送的控制中心类，该类负责处理发送请求前合并请求的参数、请求头数据、log输出、批量、链式请求的逻辑处理|
|NXNWBridge|请求桥接类，将上层的请求配置类与底层网络请求框架类(现在使用的是AF)相关联|
|NXNWDownLoad|文件下载器,支持断点续传|

## 功能介绍
### 基本配置
因为配置对象是一个单例（NXNWConfig），所以可以在项目任何地方来使用。看一下该框架支持哪些配置项：
#### 服务器地址
```objective-c
[NXNWConfig shareInstanced].baseUrl = @"http://data.philm.cc/sticker/2017/v18/";
```
#### 默认参数:
```objective-c
[NXNWConfig shareInstanced].globalParams.addString(@"param1",@"1234");
```
> 默认参数会拼接在所有请求的请求体中；
如果是GET请求，则拼接在url里面。

#### 默认请求头
```objective-c
[NXNWConfig shareInstanced].globalHeaders.addString(@"header1",@"defualtHeaders");
```
> 添加的请求头键值对会自动添加到所有的请求头中；
如果键值对原来不存在，则添加；如果原来存在，则替换原有的。

#### 是否有日志输出
```objective-c
[NXNWConfig shareInstanced].consoleLog = YES;
```
> 如果consoleLog 为YES则在会有详细的log输出
  如果为NO 则没有log
  
#### 设置请求回调队列
```objective-c
[NXNWConfig shareInstanced].callbackQueue = dispatch_get_main_queue();
```
> 设置请求回调队列，默认在主线程。可以自定义到其他线程中

#### GET请求示例
```objective-c
    NXNWRequest * request = [[NXNWRequest alloc] initWithAPIPath:@"check_version.json"];
    request.requstType = NXNWRequestTypeNormal;
    request.httpMethod = NXHTTPMethodTypeOfGET;
    request.params.addDouble(@"time",12345).addString(@"哈哈 哈",@"汉 字");
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
```

### Post请求示例
```objective-c
    NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/"];
    request.apiPath = @"post";
    request.params.addString(@"key",@"value");
    request.requstType = NXNWRequestTypeNormal;
    request.httpMethod = NXHTTPMethodTypeOfPOST;
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
```
### Delete 请求示例
```objective-c
   NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/delete"];
    request.params.addString(@"key",@"value");
    request.httpMethod = NXHTTPMethodTypeOfDELETE;
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    [request start];
```

### Put请求示例
```objecitive-c
    NXNWRequest * requst = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/put"];
    requst.params.addString(@"value",@"key");
    requst.ingoreDefaultHttpHeaders = YES;
    requst.ingoreDefaultHttpParams = YES;
    requst.httpMethod  = NXHTTPMethodTypeOfPUT;
    [requst start];
```
### header请求示例
```objecitve-c
    NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/headers"];
    request.params.addString(@"key",@"value");
    request.requstType = NXNWRequestTypeNormal;
    request.httpMethod = NXHTTPMethodTypeOfHEAD;
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
        NSLog(@"sssssssssssss");
    } failure:^(NSError *error, NXNWRequest *rq) {
        
        NSLog(@"ffffffffffffff");
    }];
```

### patch请求示例
```objective-c
 NXNWRequest * requset = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/patch"];
    requset.params.addString(@"key",@"value");
    requset.ingoreDefaultHttpHeaders = YES;
    requset.ingoreDefaultHttpParams = YES;
    requset.httpMethod = NXHTTPMethodTypeOfPATCH;
    [requset start];
```

### 下载文件示例
```objective-c
    
  - (void)startDownLoad:(id)sender {
    
    NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    request.params.addDouble(@"age",12);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    request.fileUrl = path;
    request.requstType = NXNWRequestTypeDownload;
    request.isBreakpoint = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [request startWithProgress:^(NSProgress * progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressUI.progress = progress.fractionCompleted;
            
        });
        
        
        NSLog(@"总大小:%lld 已经下载:%lld 进度:%f",progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
        
    } success:^(id responseObject, NXNWRequest *rq) {
        
        NSLog(@"下载成功");
    } failure:^(NSError *error, NXNWRequest *rq) {
        
        NSLog(@"error = %@",error);
    }];
    self.request = request;
}

 - (void)pauseDownLoad:(id)sender {
    
    [self.request pauseRequest];
}
- (void)cancelDownLoad:(id)sender {
    [self.request cancelRequset];
}
- (void)continueDownLoad:(id)sender {
    
    [self.request resumeRequst];
}
```

#### 上传文件示例
```objective-c
    NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"http://uploads.im/api"];
    
    NSURL * pathUrl = [[NSBundle mainBundle] URLForResource:@"IMG_0693" withExtension:@"JPG"];
    
    [request addFormDataWithName:@"file"
                        fileName:@"IMG_0693.JPG"
                        mimeType:@"image/jpg" fileURL:pathUrl];
    
    request.requstType = NXNWRequestTypeUpload;
    [request startWithProgress:^(NSProgress *progress) {
        
        NSLog(@"progress ---> %f",progress.fractionCompleted);
    } success:^(id responseObject, NXNWRequest *rq) {
        
        NSLog(@"upload success !!!");
    } failure:^(NSError *error, NXNWRequest *rq) {
        NSLog(@"upload failure");
    }];
```

#### 批量请求示例
```objective-c
    NXBatchRequest *batchRequest = [[NXBatchRequest alloc] init];
    [batchRequest addRequests:^(NSMutableArray *requestPool) {
       
        NXNWRequest * rq1 = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/get"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq1.params.addString(@"method",@"get");
        rq1.ingoreDefaultHttpParams = YES;
        rq1.ingoreDefaultHttpHeaders = YES;
        
        NXNWRequest * rq2 = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/put"];
        rq2.httpMethod = NXHTTPMethodTypeOfPUT;
        rq2.ingoreDefaultHttpParams = YES;
        rq2.ingoreDefaultHttpHeaders = YES;
        
        NXNWRequest * rq3 = [[NXNWRequest alloc] initWithUrl:@"https://httpbin.org/post"];
        rq3.httpMethod = NXHTTPMethodTypeOfPOST;
        rq3.params.addString(@"method",@"post");
        rq3.ingoreDefaultHttpParams = YES;
        rq3.ingoreDefaultHttpHeaders = YES;
        
        [requestPool addObject:rq1];
        [requestPool addObject:rq2];
        [requestPool addObject:rq3];
        
    }];
    
    [batchRequest startWithSuccess:^(NSArray *resposeObjs) {
       
        NSLog(@"批量 请求成功");
        
    } failure:^(NSArray *errors) {
        
        NSLog(@"批量 请求失败");
    }];
```

#### 链式请求示例
```objective-c
    NXChainRequest * chinRequest = [[NXChainRequest alloc] init];
    chinRequest.buildBlock = ^(NXNWRequest *rq, NSInteger index, BOOL *stop, id preResponseObj) {
        
        rq.config = [NXNWConfig shareInstanced];
        if(index == 0)
        {
            rq.url = @"https://httpbin.org/get";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.params.addString(@"method",@"get");
        }
        if(index == 1){
            
            rq.url = @"https://httpbin.org/post";
            rq.httpMethod = NXHTTPMethodTypeOfPOST;
            rq.params.addString(@"method",@"post");
            
        }
            
        *stop = (index >= 2);
    };
    [chinRequest startWithSucces:^(NSArray *resposeObjs) {
        
        NSLog(@"-------- chain requst success -------------");
    } failure:^(NSArray *errors) {
        
        NSLog(@"-------- chain requst failure -------------");
    }];
```
  



