//
//  NXDBHelper.m
//  NXDB
//
//  Created by ꧁༺ Yuri ༒ Boyka™ ༻꧂ on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXDBHelper.h"
#import "NXDB.h"

@interface NXDBHelper ()

@property (nonatomic, strong) NXDB *nxdb;

@property (nonatomic, strong) NXDBVersion *nxdbVersion;

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
    if (nil != (self = [super init])) {}
    return self;
}

- (void)checkDBVersion
{
    __weak typeof(self) weakSelf = self;
    [self dbOperation:NXDBOperationRead model:[NXDBVersion class] updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *latestDBVersion = [NXDBUtil nx_database_version];
        if ([dataSet count] == 0)
        {
            [strongSelf updateDBVersion:latestDBVersion];
        }
        else
        {
            NXDBVersion *currentDBVersion = ((NXDBVersion *)[dataSet lastObject]);
            if(![currentDBVersion.version isEqualToString:latestDBVersion])
            {
#ifndef NXDBLOGDISABLE
                NSLog(@"[当前数据库版本号:%@ 升级数据库版本号:%@]", ((NXDBVersion *)[dataSet lastObject]).version, latestDBVersion);
#endif
                [self vacuumDB];
                [strongSelf updateDBVersion:latestDBVersion];
            }
            else
            {
                _nxdbVersion = currentDBVersion;
            }
        }
    }];
}

- (void)updateDBVersion:(NSString *)version
{
    NXDBVersion *dbVersion = [[NXDBVersion alloc] init];
    dbVersion.version = version;
    dbVersion.timestamp = [NSString stringWithFormat:@"%llu", (long long)[[NSDate date] timeIntervalSince1970]];
    _nxdbVersion = dbVersion;
    [self dbOperation:NXDBOperationCreate model:dbVersion updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:YES completionHandler:^(BOOL operationResult, id dataSet) {
        if (operationResult) {
#ifndef NXDBLOGDISABLE
            NSLog(@"[数据库版本存储成功]");
#endif
        }
    }];
}

- (void)dbChanges:(void(^)(NSString *str))change
{
    __weak typeof(self) weakSelf = self;
    [self dbOperation:NXDBOperationRead model:_nxdbVersion updateAttributes:nil orderBy:nil limit:0 condition:nil inTrasaction:NO completionHandler:^(BOOL operationResult, id dataSet) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.nxdbVersion = [dataSet lastObject];
#ifndef NXDBLOGDISABLE
        NSLog(@"[数据库字段变更]:%@", strongSelf.nxdbVersion.changes);
#endif
        if (change) change(strongSelf.nxdbVersion.changes);
    }];
}

- (void)setDbPath:(NSString *)dbPath
{
    _nxdb = [NXDB nx_databaseWithPath:dbPath];
    [self checkDBVersion];
}

- (void)vacuumDB
{
    [_nxdb nx_vacuumDB];
}

- (void)insertObject:(id)model
   completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationCreate model:model updateAttributes:nil orderBy:nil limit:0 condition:[NXDBUtil sqlConditionWithArray:nil] inTrasaction:YES completionHandler:callback];
}

- (void)deleteObject:(id)model
   completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationDelete model:model updateAttributes:nil orderBy:nil limit:0 condition:[NXDBUtil sqlConditionWithArray:nil] inTrasaction:NO completionHandler:callback];
}

- (void)updateObject:(id)model
    updateAttributes:(NSDictionary *)updateAttributes
          conditions:(NSArray *)conditions
   completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationRead model:model updateAttributes:updateAttributes orderBy:nil limit:0 condition:[NXDBUtil sqlConditionWithArray:conditions] inTrasaction:NO completionHandler:callback];
}

- (void)queryObject:(id)model
         conditions:(NSArray *)conditions
  completionHandler:(NXDBOperationCallback)callback
{
    [self queryObject:model conditions:conditions orderBy:nil limit:0 completionHandler:callback];
}

- (void)queryObject:(id)model
         conditions:(NSArray *)conditions
            orderBy:(NSString *)orderBy
              limit:(NSInteger)limit
  completionHandler:(NXDBOperationCallback)callback
{
    [self dbOperation:NXDBOperationRead model:model updateAttributes:nil orderBy:orderBy limit:limit condition:conditions?[NXDBUtil sqlConditionWithArray:conditions]:nil inTrasaction:NO completionHandler:callback];
}

- (long)querySqlTableCount:(id)model
{
    return [self.nxdb nx_countInDataBaseWithClass:[NXDBUtil modelClass:model] withTableName:nil cond:nil];
}

- (NSArray *)resultDictionaryWithModel:(id)model
{
    return [self.nxdb nx_getResultDictionaryWithTableName:NSStringFromClass([NXDBUtil modelClass:model]) customCond:nil];
}

- (void)dbOperation:(NXDBOperation)op
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
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __weak typeof(weakSelf) strongSelf = self;
        
        unsigned long modelCount = [model isKindOfClass:[NSArray class]] ? [model count] : 1;
        
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        
        Class modelClass = [NXDBUtil modelClass:model];
        
        __block BOOL result = NO;
        
        id data = model;
        
        switch (op) {
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
                        result = [strongSelf.nxdb nx_addObjectsInTransaction:@[model] WithTableName:nil];
                    }
                    else
                    {
                        result = [strongSelf.nxdb nx_addObject:model WithTableName:nil];
                    }
                }
            }
                break;
            case NXDBOperationRead:
            {
                data = [strongSelf.nxdb nx_getObjectsWithClass:modelClass withTableName:nil orderBy:orderBy limit:limit cond:condition];
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
                NSArray * datas = [self.nxdb nx_getAllObjectsWithClass:modelClass];
                result = [self.nxdb nx_deleteObject:[datas firstObject]];
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
        NSLog(@"[%@%lu条数据%@], [用时]:%.2fms", opDesc, modelCount, result?@"成功":@"失败", linkTime *1000.0);
#endif
    });
}

@end
