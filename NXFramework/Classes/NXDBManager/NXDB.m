//
//  NXDB.m
//  NXDB
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXDB.h"
#import "FMDB.h"
#import <objc/runtime.h>
#import "NXDBCoreInterface.h"


@implementation NXDBCondition

+ (instancetype)conditionWithProperty:(NSString *)property compare:(NSString *)compare value:(id)value
{
    NXDBCondition *condition = [[NXDBCondition alloc] init];
    condition.property = property;
    condition.compare = compare;
    condition.value = value;
    return condition;
}

+ (instancetype)conditionWithString:(NSString *)condition
{
    NSArray *conditions = [condition componentsSeparatedByString:@"|"];
    if (conditions.count == 3)
    {
        NXDBCondition *condition = [[NXDBCondition alloc] init];
        condition.property = conditions[0];
        condition.compare = conditions[1];
        condition.value = conditions[2];
        return condition;
    }
    return nil;
}

@end

@interface NXDB ()
@property(nonatomic, strong) NSMutableArray *obj_array;
@property(nonatomic, strong) NSString *sqlCondition;
@end

@implementation NXDB

+ (instancetype)nx_databaseWithPath:(NSString *)dbPath
{
    NXDB *database = [[NXDB alloc] initWithDBPath:dbPath];
    return database;
}

#pragma mark - public Method

- (BOOL)nx_addObject:(id<NXDBObjectProtocol>)obj
{
    return [self nx_addObject:obj WithTableName:NSStringFromClass([obj class])];
}

- (BOOL)nx_addObjects:(NSArray *)objs
{
    if (!objs || objs.count <= 0)
    {
        return NO;
    }
    [self nx_tableCheck:objs[0]];
    __block NSMutableArray *array = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        for (NSObject *obj in objs)
        {
            NSString *query = [self nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)obj];
            BOOL isSuccess = [db executeUpdate:query, nil];
            if (!isSuccess)
            {
                [array addObject:obj];
            }
        }
    }];

    return !(array.count > 0);
}

- (BOOL)nx_addObject:(id<NXDBObjectProtocol>)obj WithTableName:(NSString *)tableName
{
    if (!obj)
    {
        return NO;
    }
	//如果表名为空 使用model 的类名
    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass([obj class]);
    }
    [self nx_tableCheck:obj];

    __block BOOL isSuccess = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *query = [self nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)obj withTableName:tableName];
        isSuccess = [db executeUpdate:query, nil];
    }];
    return isSuccess;
}

- (BOOL)nx_addObjects:(NSArray *)objs WithTableName:(NSString *)tableName
{
    if (!objs || objs.count <= 0)
    {
        return NO;
    }

    [self nx_tableCheck:objs[0]];
    __block NSMutableArray *array = [NSMutableArray array];
    __block NSString *sheetName = tableName;
    [self.dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        for (NSObject *obj in objs)
        {
            if (!sheetName || [sheetName isEqualToString:@""])
            {
                sheetName = NSStringFromClass([obj class]);
            }
            NSString *query = [self nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)obj withTableName:sheetName];
            BOOL isSuccess = [db executeUpdate:query, nil];
            if (!isSuccess)
            {
                [array addObject:obj];
            }
        }
    }];

    return !(array.count > 0);
}

- (BOOL)nx_addObjectsInTransaction:(NSArray *)objs WithTableName:(NSString *)tableName
{
    if (!objs || objs.count <= 0)
    {
        return NO;
    }

    [self nx_tableCheck:objs[0]];
    __block NSMutableArray *array = [NSMutableArray array];
    __block NSString *sheetName = tableName;
    [self.dbQueue inTransaction:^(FMDatabase *_Nonnull db, BOOL *_Nonnull rollback) {
        for (id<NXDBObjectProtocol> obj in objs)
        {
            if (!sheetName || [sheetName isEqualToString:@""])
            {
                sheetName = NSStringFromClass([obj class]);
            }
            NSString *query = [self nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)obj withTableName:sheetName];
            BOOL isSuccess = [db executeUpdate:query, nil];
            if (!isSuccess)
            {
                [array addObject:obj];
                *rollback = YES;
            }
        }
    }];
    return !(array.count > 0);
}

/**
 修改数据
 */
- (BOOL)nx_updateObjectClazz:(Class)clazz keyValues:(NSDictionary *)keyValues cond:(NSString *)predicateFormat, ...
{
    if (keyValues.allValues.count <= 0 || !keyValues)
    {
        return NO;
    }
    va_list arglist;
    va_start(arglist, predicateFormat);
    NSString *tableName = NSStringFromClass(clazz);
    return [self nx_updateTableName:tableName objectClazz:clazz keyValues:keyValues cond:predicateFormat, arglist];
}

- (BOOL)nx_updateTableName:(NSString *)tableName
               objectClazz:(Class)clazz
                 keyValues:(NSDictionary *)keyValues
                      cond:(NSString *)predicateFormat, ...
{
    if (keyValues.allValues.count <= 0 || !keyValues)
    {
        return NO;
    }

    __block NSString *sql = [NSString stringWithFormat:@"UPDATE %s SET", [tableName UTF8String]];
    [keyValues enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {

        objc_property_t property = class_getProperty(clazz, key.UTF8String);
        NSString *property_value = @"";
        if ([[self nx_getSqlKindbyProperty:property] isEqualToString:@"text"])
        {
            NSString *value = [NSString stringWithFormat:@"%@", obj];
            NSString *property_sign = [self nx_getPropertySign:property];
            if ([property_sign isEqualToString:@"@\"NSString\""] || [property_sign isEqualToString:@"@"])
            {
            }

            property_value = [NSString stringWithFormat:@"'%@'", value];
            ;
        }
        else
        {
            property_value = [NSString stringWithFormat:@"%@", [obj stringValue]];
        }
        NSString *keyName = [self nx_processReservedWord:key];
        sql = [NSString stringWithFormat:@"%@ %@=%@,", sql, keyName, property_value];
    }];
    // 删除最后一个逗号
    sql = [self nx_removeLastOneChar:sql];

    va_list arglist;

    if (predicateFormat)
    {
        va_start(arglist, predicateFormat);
        NSString *condition = [[NSString alloc] initWithFormat:predicateFormat arguments:arglist];
        sql = [NSString stringWithFormat:@"%@ WHERE %@", sql, [self nx_formatConditionString:condition]];
    }

    __block BOOL sucess = NO;
    [self.dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
        sucess = [db executeUpdate:sql, nil];
    }];
    return sucess;
}

/// 获取数据表中的全部数据
- (NSArray *)nx_getAllObjectsWithClass:(Class)clazz withTableName:(NSString *)tableName
{
    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass(clazz);
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %s", [tableName UTF8String]];
    return [self nx_excuteSql:sql withClass:clazz];
}

- (NSArray *)nx_getAllObjectsWithClass:(Class)clazz
{
    NSString *tableName = NSStringFromClass(clazz);
    return [self nx_getAllObjectsWithClass:clazz withTableName:tableName];
}

/// 根据condition获取数据表中符合条件的数据
- (NSArray *)nx_getObjectsWithClass:(Class)clazz whereCond:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *condition = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    NSString *tableName = NSStringFromClass(clazz);
    NSString *sql = [NSString stringWithFormat:@"select * from %s where ", [tableName UTF8String]];
    sql = [sql stringByAppendingString:[self nx_formatConditionString:condition]];

    return [self nx_excuteSql:sql withClass:clazz];
}

- (NSArray *)nx_getObjectsWithClass:(Class)clazz withTableName:(NSString *)tableName whereCond:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *condition = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass(clazz);
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %s where ", [tableName UTF8String]];
    sql = [sql stringByAppendingString:[self nx_formatConditionString:condition]];

    return [self nx_excuteSql:sql withClass:clazz];
}

- (NSArray *)nx_getObjectsWithClass:(Class)clazz
                      withTableName:(NSString *)tableName
                         customCond:(NSString *)predicateFormat, ...
{
    va_list args;
    va_start(args, predicateFormat);
    NSString *condition = [[NSString alloc] initWithFormat:predicateFormat arguments:args];
    va_end(args);

    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass(clazz);
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %s ", [tableName UTF8String]];
    sql = [sql stringByAppendingString:[self nx_formatConditionString:condition]];

    return [self nx_excuteSql:sql withClass:clazz];
}

- (NSArray *)nx_getObjectsWithClass:(Class)clazz
                      withTableName:(NSString *)tableName
                            orderBy:(NSString *)orderName
                              limit:(NSInteger)count
                               cond:(NSString *)predicateFormat, ...
{
    NSString *condition = @"";
    if (predicateFormat)
    {
        va_list arglist;
        va_start(arglist, predicateFormat);
        condition = [[NSString alloc] initWithFormat:predicateFormat arguments:arglist];
    }
    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass(clazz);
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %s ", [tableName UTF8String]];

    sql = [NSString stringWithFormat:@"%@ %@", sql, [self nx_formatConditionString:condition]];

    if (orderName || orderName.length > 0)
    {
        sql = [NSString stringWithFormat:@"%@ order by %@", sql, orderName];
    }

    if (count > 0)
    {
        sql = [NSString stringWithFormat:@"%@ limit %ld", sql, count];
    }

    return [self nx_excuteSql:sql withClass:clazz];
}

- (NSArray *)nx_getResultDictionaryWithTableName:(NSString *)tableName customCond:(NSString *)predicateFormat, ...
{
    NSString *condition = @"";
    if (predicateFormat)
    {
        va_list arglist;
        va_start(arglist, predicateFormat);
        condition = [[NSString alloc] initWithFormat:predicateFormat arguments:arglist];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %s ", [tableName UTF8String]];
    return [self nx_excuteSql:sql];
}

- (long)nx_countInDataBaseWithClass:(Class)clazz
                      withTableName:(NSString *)tableName
                               cond:(NSString *)predicateFormat, ...
{
    NSString *condition = nil;
    if (predicateFormat)
    {
        va_list arglist;
        va_start(arglist, predicateFormat);
        condition = [[NSString alloc] initWithFormat:predicateFormat arguments:arglist];
    }

    if (!tableName || [tableName isEqualToString:@""])
    {
        tableName = NSStringFromClass(clazz);
    }
    __block long count = 0;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %s ", [tableName UTF8String]];

    if (condition)
    {
        sql = [NSString stringWithFormat:@"%@ WHERE %@", sql, condition];
    }

    [self.dbQueue inDatabase:^(FMDatabase *db) {
        count = [db longForQuery:sql];
    }];

    return count;
}

- (BOOL)nx_deleteObject:(id<NXDBObjectProtocol>)obj withTableName:(NSString *)tableName
{
    if (obj)
    {
        if (!tableName || [tableName isEqualToString:@""])
        {
            tableName = NSStringFromClass([obj class]);
        }
        NSString *query = [self nx_formatDeleteSQLWithObjc:obj withTableName:tableName];

        __block BOOL isSuccess = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            isSuccess = [db executeUpdate:query, nil];
        }];

        return isSuccess;
    }

    return NO;
}

- (BOOL)nx_deleteObject:(id<NXDBObjectProtocol>)obj
{
    if (!obj)
    {
        return NO;
    }
    NSString *tableName = NSStringFromClass([obj class]);
    return [self nx_deleteObject:obj withTableName:tableName];
}

- (BOOL)nx_deleteObjects:(NSArray<id<NXDBObjectProtocol>> *)objs withTableName:(NSString *)tableName
{
    __block BOOL isSuccess = NO;
    [self.dbQueue inTransaction:^(FMDatabase *_Nonnull db, BOOL *_Nonnull rollback) {
        __block NSString *sheetName = tableName;
        [objs enumerateObjectsUsingBlock:^(id<NXDBObjectProtocol> _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (!sheetName || [sheetName isEqualToString:@""])
            {
                sheetName = NSStringFromClass([obj class]);
            }
            NSString *query = [self nx_formatDeleteSQLWithObjc:obj withTableName:sheetName];
            isSuccess = [db executeUpdate:query, nil];
            if (!isSuccess)
            {
                *rollback = YES;
            }
        }];
    }];
    return isSuccess;
}

- (BOOL)nx_deleteObjects:(NSArray<id<NXDBObjectProtocol>> *)objs
{
    return [self nx_deleteObjects:objs withTableName:nil];
}

- (BOOL)nx_removeTableWithClass:(Class)clazz
{
    NSString *sheet_name = NSStringFromClass(clazz);
    return [self nx_removeTable:sheet_name];
}

- (BOOL)nx_removeTable:(NSString *)table_name
{
    __block BOOL isSuccess = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [@"DROP TABLE " stringByAppendingString:table_name];
        isSuccess = [db executeUpdate:sql, nil];
    }];
    return isSuccess;
}

- (BOOL)nx_vacuumDB
{
    __block BOOL isSuccess = NO;
    [self.dbQueue inDatabase:^(FMDatabase *_Nonnull db) {
#ifndef NXDBLOGDISABLE
        NSLog(@"[VACUUM开始]");
#endif
        isSuccess = [db executeUpdate:@"VACUUM"];
        if (isSuccess)
        {
#ifndef NXDBLOGDISABLE
            NSLog(@"[VACUUM结束]");
#endif
        }
        else
        {
#ifndef NXDBLOGDISABLE
            NSLog(@"[VACUUM失败]");
#endif
        }
    }];
    return isSuccess;
}

#pragma mark - condition Method

- (instancetype)nx_selectClazz:(Class)clazz
{
    NSString *tableName = NSStringFromClass(clazz);
    self.sqlCondition = [NSString stringWithFormat:@"select * from %s", [tableName UTF8String]];
    return self;
}

- (instancetype)nx_selectTableName:(NSString *)tableName
{
    self.sqlCondition = [NSString stringWithFormat:@"select * from %s", [tableName UTF8String]];
    return self;
}

- (instancetype)nx_whereProperty:(NSString *)propertyName
{
    NSString *keyName = [self nx_processReservedWord:propertyName];
    self.sqlCondition = [NSString stringWithFormat:@"%@ where %@", self.sqlCondition, keyName];
    return self;
}

- (instancetype)nx_andProperty:(NSString *)propertyName
{
    NSString *keyName = [self nx_processReservedWord:propertyName];

    self.sqlCondition = [NSString stringWithFormat:@"%@ and %@", self.sqlCondition, keyName];
    return self;
}

- (instancetype)nx_equal:(id)value
{
    if ([value isKindOfClass:[NSString class]])
    {
        self.sqlCondition = [NSString stringWithFormat:@"%@='%@'", self.sqlCondition, value];
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        NSInteger intValue = [(NSNumber *)value integerValue];
        self.sqlCondition = [NSString stringWithFormat:@"%@=%ld", self.sqlCondition, intValue];
    }
    else
    {
        NSInteger intValue = (NSInteger)value;
        self.sqlCondition = [NSString stringWithFormat:@"%@=%ld", self.sqlCondition, intValue];
    }

    return self;
}

- (instancetype)nx_equalMore:(NSInteger)value
{
    self.sqlCondition = [NSString stringWithFormat:@"%@>=%ld", self.sqlCondition, value];
    return self;
}

- (instancetype)nx_equalLess:(NSInteger)value
{
    self.sqlCondition = [NSString stringWithFormat:@"%@<=%ld", self.sqlCondition, value];
    return self;
}

- (instancetype)nx_more:(NSInteger)value
{
    self.sqlCondition = [NSString stringWithFormat:@"%@>%ld", self.sqlCondition, value];
    return self;
}

- (instancetype)nx_less:(NSInteger)value
{
    self.sqlCondition = [NSString stringWithFormat:@"%@<%ld", self.sqlCondition, value];
    return self;
}

- (instancetype)nx_orderby:(NSString *)propertyName asc:(BOOL)asc
{
    NSString *orderCond = asc ? @"ASC" : @"DESC";
    self.sqlCondition = [NSString stringWithFormat:@"%@ order by %@ %@", self.sqlCondition, propertyName, orderCond];

    return self;
}

- (instancetype)nx_limit:(int)count
{
    self.sqlCondition = [NSString stringWithFormat:@"%@ limit %d", self.sqlCondition, count];
    return self;
}

- (NSArray *)nx_queryObjectsWithClazz:(Class)clazz
{
    NSError *error;
    [self.dataBase validateSQL:self.sqlCondition error:&error];
    if (error)
    {
        NSAssert(!error, @"SQLCondition is not validatesql -- %@", self.sqlCondition);
    }
    return [self nx_excuteSql:self.sqlCondition withClass:clazz];
}

@end
