//
//  NXNSJSONSerialization.h
//
//  Created by AK on 15/2/28.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXNSJSONSerialization : NSObject

// 解析json 返回对象
+ (id)objectFromData:(NSData *)data;
// 将对象构造成json
+ (NSData *)dataFromObject:(id)object;

+ (id)objectFromData:(NSData *)data error:(NSError **)error;
+ (NSData *)dataFromObject:(id)object error:(NSError **)error;

+ (id)objectFromString:(NSString *)string;
+ (NSString *)stringFromObject:(id)object;

+ (id)objectFromString:(NSString *)string error:(NSError **)error;
+ (NSString *)stringFromObject:(id)object error:(NSError **)error;

@end
