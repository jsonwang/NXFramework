//
//  NXDBHelper.h
//  NXDB
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBUtil.h"

// 若要屏蔽LOG， 请定义宏NXDBLOGDISABLE

/*
 数据库回调
 operationResult 操作结果
 dataSet 结果数据
 */
typedef void (^NXDBOperationCallback)(BOOL operationResult, id dataSet);

@interface NXDBHelper : NSObject

@property(nonatomic, copy) NSString *dbPath;  // 数据库路径

/**
 单例

 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 插入

 @param model 数据对象
 @param callback 回调
 */
- (void)insertObject:(id)model completionHandler:(NXDBOperationCallback)callback;

/**
 删除

 @param model 对象
 @param callback 回调
 */
- (void)deleteObject:(id)model completionHandler:(NXDBOperationCallback)callback;

/**
 更新

 @param model 对象
 @param updateAttributes 更新的属性
 @param conditions 条件
 @param callback 回调
 */
- (void)updateObject:(id)model
    updateAttributes:(NSDictionary *)updateAttributes
          conditions:(NSArray *)conditions
   completionHandler:(NXDBOperationCallback)callback;

/**
 查询

 @param model 对象
 @param conditions 条件
 @param callback 回调
 */
- (void)queryObject:(id)model conditions:(NSArray *)conditions completionHandler:(NXDBOperationCallback)callback;

/**
 查询

 @param model 对象
 @param conditions 条件
 @param orderBy 顺序
 @param limit 限制
 @param callback 回调
 */
- (void)queryObject:(id)model
         conditions:(NSArray *)conditions
            orderBy:(NSString *)orderBy
              limit:(NSInteger)limit
  completionHandler:(NXDBOperationCallback)callback;

/**
 查询SqlTable数量

 @param model 对象
 @return 返回数量
 */
- (long)querySqlTableCount:(id)model;

/**
 结果集

 @param model 对象
 @return 结果集
 */
- (NSArray *)resultDictionaryWithModel:(id)model;

/**
 DB操作

 @param op 数据库操作类型
 @param model 对象
 @param updateAttributes 更新属性
 @param orderBy 排序
 @param limit 限制
 @param condition 条件
 @param inTrasaction 事务标识
 @param callback 回调
 */
- (void)dbOperation:(NXDBOperation)op
              model:(id)model
   updateAttributes:(NSDictionary *)updateAttributes
            orderBy:(NSString *)orderBy
              limit:(NSInteger)limit
          condition:(NSString *)condition
       inTrasaction:(BOOL)inTrasaction
  completionHandler:(NXDBOperationCallback)callback;

@end
