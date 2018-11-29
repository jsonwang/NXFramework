//
//  NXDBHelper.m
//  NXDB
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXDBHelper.h"
#import "NXDB.h"

static dispatch_queue_t nxdb_operation_queue;  // nxdb操作队列

@interface NXDBHelper ()

@property(nonatomic, strong) NXDB *nxdb;

@end

@implementation NXDBHelper

static NXDBHelper *helper;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NXDBHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    if (helper) return helper;
    if (nil != (self = [super init]))
    {
        nxdb_operation_queue = dispatch_queue_create("com.nxdb.concurrent.queue", DISPATCH_CURRENT_QUEUE_LABEL);
    }
    return self;
}

- (void)setDbPath:(NSString *)dbPath { _nxdb = [NXDB nx_databaseWithPath:dbPath]; }
- (void)vacuumDB { [_nxdb nx_vacuumDB]; }
- (void)insertObject:(id)model completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationCreate
                    model:model
         updateAttributes:nil
                  orderBy:nil
                    limit:0
                condition:[NXDBUtil sqlConditionWithArray:nil]
             inTrasaction:YES
        completionHandler:callback];
}

- (void)deleteObject:(id)model completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationDelete
                    model:model
         updateAttributes:nil
                  orderBy:nil
                    limit:0
                condition:[NXDBUtil sqlConditionWithArray:nil]
             inTrasaction:NO
        completionHandler:callback];
}

- (void)updateObject:(id)model
    updateAttributes:(NSDictionary *)updateAttributes
          conditions:(NSArray *)conditions
   completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationUpdate
                    model:model
         updateAttributes:updateAttributes
                  orderBy:nil
                    limit:0
                condition:[NXDBUtil sqlConditionWithArray:conditions]
             inTrasaction:NO
        completionHandler:callback];
}

- (id)syncQueryObject:(id)model conditions:(NSArray *)conditions
{
    return [self queryObject:model
                   operation:NXDBOperationReadSync
                  conditions:conditions
                     orderBy:nil
                       limit:0
           completionHandler:nil];
}

- (id)queryObject:(id)model conditions:(NSArray *)conditions completionHandler:(NXDBOperationCallback)callback
{
    return [self queryObject:model
                   operation:NXDBOperationRead
                  conditions:conditions
                     orderBy:nil
                       limit:0
           completionHandler:callback];
}

- (id)queryObject:(id)model
        operation:(NXDBOperation)op
       conditions:(NSArray *)conditions
          orderBy:(NSString *)orderBy
            limit:(NSInteger)limit
completionHandler:(NXDBOperationCallback)callback
{
    return [self dbOperation:op
                       model:model
            updateAttributes:nil
                     orderBy:orderBy
                       limit:limit
                   condition:conditions ? [NXDBUtil sqlConditionWithArray:conditions] : nil
                inTrasaction:NO
           completionHandler:callback];
}

- (long)querySqlTableCount:(id)model
{
    return [self.nxdb nx_countInDataBaseWithClass:[NXDBUtil modelClass:model] withTableName:nil cond:nil];
}

- (NSArray *)resultDictionaryWithModel:(id)model
{
    return
        [self.nxdb nx_getResultDictionaryWithTableName:NSStringFromClass([NXDBUtil modelClass:model]) customCond:nil];
}

- (id)dbOperation:(NXDBOperation)op
            model:(id)model
 updateAttributes:(NSDictionary *)updateAttributes
          orderBy:(NSString *)orderBy
            limit:(NSInteger)limit
        condition:(NSString *)condition
     inTrasaction:(BOOL)inTrasaction
completionHandler:(NXDBOperationCallback)callback
{
    NSString *opDesc = [NXDBUtil operationDescription:op];
    if (!model)
    {
#ifndef NXDBLOGDISABLE
        NSLog(@"[%@对象不能为空!]", opDesc);
#endif
        return nil;
    }

    __block id data = nil;

    __weak typeof(self) weakSelf = self;

    dispatch_operation((op != NXDBOperationReadSync), ^{
        __weak typeof(weakSelf) strongSelf = self;

        unsigned long modelCount = [model isKindOfClass:[NSArray class]] ? [model count] : 1;

        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

        Class modelClass = [NXDBUtil modelClass:model];

        __block BOOL result = NO;

        switch (op)
        {
            case NXDBOperationCreate:
            {
                if ([model isKindOfClass:[NSArray class]])
                {
                    if (inTrasaction)
                    {
                        result = [strongSelf.nxdb nx_addObjectsInTransaction:model WithTableName:nil];
                    }
                    else
                    {
                        result = [strongSelf.nxdb nx_addObjects:model WithTableName:nil];
                    }
                }
                else
                {
                    if (inTrasaction)
                    {
                        result = [strongSelf.nxdb nx_addObjectsInTransaction:@[ model ] WithTableName:nil];
                    }
                    else
                    {
                        result = [strongSelf.nxdb nx_addObject:model WithTableName:nil];
                    }
                }
            }
            break;
            case NXDBOperationRead:
            case NXDBOperationReadSync:
            {
                data = [strongSelf.nxdb nx_getObjectsWithClass:modelClass
                                                 withTableName:nil
                                                       orderBy:orderBy
                                                         limit:limit
                                                          cond:condition];
                modelCount = [data count];
                result = data;
            }
            break;
            case NXDBOperationUpdate:
            {
                result = [self.nxdb nx_updateObjectClazz:modelClass keyValues:updateAttributes cond:condition];
            }
            break;
            case NXDBOperationDelete:
            {
                // mdf by ak delete 后续优化
                NSArray *datas = [strongSelf.nxdb nx_getObjectsWithClass:modelClass
                                                           withTableName:nil
                                                                 orderBy:orderBy
                                                                   limit:limit
                                                                    cond:condition];

                result = [self.nxdb nx_deleteObjects:datas withTableName:nil];
            }
            break;

            default:
                break;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) callback(result, data);
        });

        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);

#ifndef NXDBLOGDISABLE
        NSLog(@"[%@%lu条数据%@], [用时]:%.2fms", opDesc, modelCount, result ? @"成功" : @"失败", linkTime * 1000.0);
#endif
    });
    return data;
}

static inline void dispatch_operation(BOOL async, void (^block)(void))
{
    if (async)
    {
        dispatch_async(nxdb_operation_queue, block);
    }
    else
    {
        dispatch_sync(nxdb_operation_queue, block);
    }
}

@end
