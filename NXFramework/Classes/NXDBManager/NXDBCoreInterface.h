//
//  NXDBCoreInterface.h
//  NXDB
//
//  Created by ꧁༺ Yuri ༒ Boyka™ ༻꧂ on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"
#import "NXDBUtil.h"

@class FMDatabaseQueue,FMDatabase,FMResultSet;

@interface NXDBCore ()
@property (nonatomic, strong, readonly) FMDatabase * dataBase;
@property (nonatomic, copy  ) NSString * dbFile;
@property (nonatomic, strong) FMDatabaseQueue * dbQueue;
@property (nonatomic, strong) NSArray * sqliteReservedWords;

- (instancetype)initWithDBPath:(NSString*)dbPath;

- (BOOL)nx_dbFileExist;

#pragma mark - table check

- (void)nx_tableCheck:(id<NXDBObjectProtocol>)dataObject;
- (void)nx_tableCheck:(id<NXDBObjectProtocol>)dataObject withTableName:(NSString *)tableName;

#pragma mark - table Create Method

- (void)nx_createTable:(FMDatabase *)db table_name:(NSString *)table_name fileds:(NSArray *)fileds isAutoPrimaryKey:(BOOL)isAuto primaryKey:(NSArray<NSString *> *)primaryKey objClass:(Class)objClass;
- (void)nx_createTableSingleKey:(FMDatabase*)db table_name:(NSString*)table_name fileds:(NSArray*)fileds primaryKey:(NSString*)primaryKey objClass:(Class)objClass;
- (void)nx_createTableMutablePK:(FMDatabase*)db table_name:(NSString*)table_name fileds:(NSArray*)fileds primaryKey:(NSArray<NSString *> *)primaryKeyArr objClass:(Class)objClass;

#pragma mark - insert record Method

- (NSString *)nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)dataObject;
- (NSString *)nx_getInsertRecordQuery:(id<NXDBObjectProtocol>)dataObject withTableName:(NSString *)tableName;
- (void)nx_insertCol:(NSString*)colName db:(FMDatabase*)db objClass:(Class)objClass;

#pragma mark - excuteSql Method

- (NSArray*)nx_excuteSql:(NSString*)sql;
- (NSArray*)nx_excuteSql:(NSString*)sql withClass:(Class)clazz;

#pragma mark - SQL format Method

- (NSString *)nx_formatDeleteSQLWithObjc:(id<NXDBObjectProtocol>)data_obj withTableName:(NSString*)tableName;
- (NSString *)nx_formatSingleConditionSQLWithObjc:(id<NXDBObjectProtocol>)data_obj property_name:(NSString *)property_name;
- (NSString *)nx_formatMutableConditionSQLWithObjc:(id<NXDBObjectProtocol>)data_obj pkArr:(NSArray *)pkArr;
- (NSString*)nx_getPropertySign:(objc_property_t)property;
- (NSString*)nx_getSqlKindbyProperty:(objc_property_t)property;

#pragma mark - convert Model Method

- (void)nx_setProperty:(id)model value:(FMResultSet *)rs columnName:(NSString *)columnName property:(objc_property_t)property;

#pragma mark - help Method

- (NSData *)nx_convertHexStrToData:(NSString *)_str;
- (NSString *)nx_formatConditionString:(NSString*)condition;
- (NSString *)nx_removeLastOneChar:(NSString*)origin;
/// 处理和解码sqlite 保留字段
- (NSString *)nx_processReservedWord:(NSString*)property_key;
- (NSString *)nx_deProcessReservedWord:(NSString*)property_key;
@end

