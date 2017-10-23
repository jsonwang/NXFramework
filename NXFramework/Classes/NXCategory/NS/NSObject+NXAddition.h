//
//  NSObject+NXAddition.h
//  NXlib
//
//  Created by AK on 3/28/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const NXObjcTypeChar;
extern NSString *const NXObjcTypeInt;
extern NSString *const NXObjcTypeShort;
extern NSString *const NXObjcTypeInt32;
extern NSString *const NXObjcTypeInt64;

extern NSString *const NXObjcTypeUChar;
extern NSString *const NXObjcTypeUInt;
extern NSString *const NXObjcTypeUShort;
extern NSString *const NXObjcTypeUInt32;
extern NSString *const NXObjcTypeUInt64;

extern NSString *const NXObjcTypeFloat;
extern NSString *const NXObjcTypeDouble;

extern NSString *const NXObjcTypeBool;

extern NSString *const NXObjcTypeCGPoint;
extern NSString *const NXObjcTypeCGSize;
extern NSString *const NXObjcTypeCGRect;

extern NSString *const NXObjcTypeNSNumber;
extern NSString *const NXObjcTypeNSValue;

extern NSString *const NXObjcTypeNSDate;

extern NSString *const NXObjcTypeNSData;
extern NSString *const NXObjcTypeUIImage;

extern NSString *const NXObjcTypeNSString;

@interface NSObject (NXAddition)

+ (NSDictionary *)nx_codableProperties;
- (NSDictionary *)nx_codableProperties;

+ (NSDictionary *)nx_storableProperties;
- (NSDictionary *)nx_storableProperties;

/**
 * 给对象的属性设置默认值, 设置只支持 nsstring ,nsnumber, NSArray
 */
- (void)checkPropertyEntity;

@end
