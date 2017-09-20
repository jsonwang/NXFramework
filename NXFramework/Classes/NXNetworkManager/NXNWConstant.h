//
//  NXConstant.h
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/8.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#ifndef NXConstant_h
#define NXConstant_h

@class NXNWRequest;
@class NSProgress;
@protocol AFMultipartFormData;
@protocol NXContainerProtol;

#pragma mark - block声明模块

typedef void(^NXCompletionHandlerBlock)(id responseObject,NSError * error, NXNWRequest * rq);

typedef void(^NXSuccesBlock)(id responseObject, NXNWRequest * rq);

typedef void (^NXFailureBlock) (NSError *error,NXNWRequest * rq);

typedef void (^NXFormDataBlock)(id<AFMultipartFormData>  formData);

typedef void (^NXProgressBlock)(NSProgress *progress);
typedef void (^NXCompletionBlock)(NXNWRequest * rq,NSError * error);

typedef  id<NXContainerProtol>(^NXContainerAddIntegerBlock)(NSInteger value,NSString * key);
typedef  id<NXContainerProtol>(^NXContainerAddDoubleBlock)(double value,NSString * key);
typedef  id<NXContainerProtol>(^NXContainerAddStringgerBlock)(NSString * value,NSString * key);

typedef void (^NXAddHeaderOrParamsBlock)(id<NXContainerProtol> container);
typedef void (^NXAddBatchRequestBlock)(NSMutableArray * requestPool);

typedef void (^NXResponseProcessBlcok)(NXNWRequest * rq,id responseObj,NSError ** error);
typedef void (^NXNWRequestProcessBlock)(NXNWRequest * rq);

typedef void (^NXBatchSuccessBlock)(NSArray* resposeObjs);
typedef void (^NXBatchFailureBlock)(NSArray* errors);

typedef void (^NXChainSuccessBlock)(NSArray * resposeObjs);
typedef void (^NXChainFailureBlock)(NSArray * errors);
typedef void (^NXChainNodeBuildBlock)(NXNWRequest * rq,NSInteger index,BOOL * stop,id preResponseObj);


#pragma mark - 协议声明模块
/**
 NXNetWorkManager 内部协议
 */
@protocol NXContainerProtol <NSObject>

- (NSDictionary *) containerConfigDic;

- (NXContainerAddIntegerBlock)addInteger;
- (NXContainerAddDoubleBlock)addDouble;
- (NXContainerAddStringgerBlock)addString;

@end

#pragma mark 枚举声明模块
typedef NS_ENUM(NSInteger,NXNWRequestType) {

    NXNWRequestTypeNormal,   /// get post put delete...
    NXNWRequestTypeUpload,   /// 上传文件
    NXNWRequestTypeDownload,/// 下载文件
};

typedef NS_ENUM(NSInteger,NXHTTPMethodType) {

    NXHTTPMethodTypeOfGET,  //get请求
    NXHTTPMethodTypeOfPOST, //post请求
    NXHTTPMethodTypeOfHEAD, //head
    NXHTTPMethodTypeOfDELETE,//delete
    NXHTTPMethodTypeOfPUT,   //put
    NXHTTPMethodTypeOfPATCH, //批量 (暂时不处理)
};

/**
 请求httpBody Content-Type的内容

 - NXHTTPRrequstSerializerTypeRAW:  设置Content-Type为   application/x-www-form-urlencoded
 - NXHTTPRrequstSerializerTypeJSON: 设置Content-Type为   application/json
 - NXHTTPRrequstSerializerTypePlist:设置Content-Type为   application/json
 */
typedef NS_ENUM(NSInteger,NXRequstSerializerType)
{
    NXHTTPRrequstSerializerTypeRAW,     ///<* application/x-www-form-urlencoded
    NXHTTPRrequstSerializerTypeJSON,   ///<* application/json
    NXHTTPRrequstSerializerTypePlist,  ///<* application/x-plist
};

/**
 响应体序列化类型

 - NXHTTResposeSerializerTypeRAW:
 - NXHTTResposeSerializerTypeJSON: 序列化成json
 - NXHTTResposeSerializerTypePlist: 序列化成plist
 - NXHTTResposeSerializerTypeXML: 序列化xml
 */
typedef NS_ENUM(NSInteger,NXResposeSerializerType) {

    NXHTTResposeSerializerTypeRAW, ///<*
    NXHTTResposeSerializerTypeJSON, ///<* json
    NXHTTResposeSerializerTypePlist, ///<* plist
    NXHTTResposeSerializerTypeXML,///<* xml
};

#endif /* NXConstant_h */
