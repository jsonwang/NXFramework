//
//  NXDBUtil.h
//  NXDB
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 db操作类型

 - NXDBOperationCreate: 添加
 - NXDBOperationRead: 查询
 - NXDBOperationReadSync: 同步查询
 - NXDBOperationUpdate: 读取
 - NXDBOperationDelete: 删除
 */
typedef NS_ENUM(NSUInteger, NXDBOperation) {
    NXDBOperationCreate,
    NXDBOperationRead,
    NXDBOperationReadSync,
    NXDBOperationUpdate,
    NXDBOperationDelete
};

static NSString *const NXDBCONDITION_EQUAL = @"E";       // 等于
static NSString *const NXDBCONDITION_GREAT = @"G";       // 大于
static NSString *const NXDBCONDITION_LESS = @"L";        // 小于
static NSString *const NXDBCONDITION_GREATTHAN = @"GT";  // 大于等于
static NSString *const NXDBCONDITION_LESSTHAN = @"LT";   // 小于等于
static NSString *const NXDBCONDITION_UNEQUAL = @"NE";    // 不等于
static NSString *const NXDBCONDITION_BETWEEN = @"BT";    // 在某个范围内
static NSString *const NXDBCONDITION_LIKE = @"LK";       // 搜索某种模式

/**
 结果集排序

 - NXDBSequenceNone: 无序
 - NXDBSequenceUp: 升序
 - NXDBSequenceDown: 降序
 */
typedef NS_ENUM(NSUInteger, NXDBSequence) { NXDBSequenceNone, NXDBSequenceUp, NXDBSequenceDown };

@interface NXDBUtil : NSObject

/**
 获取sqlite 保留字段集合

 @return NSArray
 */
+ (NSArray *)nx_sqliteReservedWords;

+ (NSString *)operationDescription:(NXDBOperation)op;

+ (Class)modelClass:(id)model;

+ (NSString *)sqlConditionWithArray:(NSArray *)conditions;

+ (NSString *)nx_database_version;

/**
 字符串是否为空,或者为空字符串

 @return YES/NO
 */
+ (BOOL)isEmpty:(NSString *)string;

@end
