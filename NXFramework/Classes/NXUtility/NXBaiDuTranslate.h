//
//  NXBaiDuTranslate.h
//  NXlib
//
//  Created by AK on 15/12/20.
//  Copyright © 2015年 AK. All rights reserved.
//

/**
 *  本类功能: 使用百度API 对字符串进行翻译

 NXBaiDuTranslate *baiduTra = [[NXBaiDuTranslate alloc] init];
 [baiduTra translateWithQuery:@"我叫AK"
 success:^(NXBaiDuTranslate *operation, id responseObject) {

 NSLog(@"翻译结果:%@", responseObject)

 }
 failure:^(NXBaiDuTranslate *operation, NSError *error) {
 NSLog(@"翻译出错:%@", error);
 }];
 */

#import <Foundation/Foundation.h>

@class NXBaiDuTranslate;

typedef void (^translateCompleteSuccess)(NXBaiDuTranslate *operation, id responseObject);

typedef void (^translateCompleteFailure)(NXBaiDuTranslate *operation, NSError *error);

@interface NXBaiDuTranslate : NSObject
{
}

@property(nonatomic, copy) translateCompleteSuccess translateCompleteSuccess;

@property(nonatomic, copy) translateCompleteFailure translateCompleteFailure;

/**
 *  对汉字进行翻译成英文
 *
 *  @param translateStr 要翻译的汉字
 *  @param success      翻译成功回调
 *  @param failure      翻译失败回调
 */
- (void)translateWithQuery:(NSString *)translateStr
                   success:(void (^)(NXBaiDuTranslate *operation, id responseObject))success
                   failure:(void (^)(NXBaiDuTranslate *operation, NSError *error))failure;

@end
