//
//  NXDB.h
//  NXDB
//
//  Created by ꧁༺ Yuri ༒ Boyka™ ༻꧂ on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBCore.h"
#import "NXDBObjectProtocol.h"

@interface NXDBVersion : NSObject <NXDBObjectProtocol>

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *changes;

@end

// 构建查询条件 [NXDBCondition conditionWithProperty:@"name" compare:NXDBCONDITION_EQUAL value:@"xiaoming"]或@"name|E|xiaoming"
@interface NXDBCondition : NSObject

+ (instancetype)conditionWithProperty:(NSString *)property
                              compare:(NSString *)compare
                                value:(id)value;

+ (instancetype)conditionWithString:(NSString *)condition;

@property (nonatomic, copy) NSString *property;

@property (nonatomic, copy) NSString *compare;

@property (nonatomic, copy) id value;

@end

@interface NXDB : NXDBCore

/**
 构造方法

 @param dbPath 如果没有文件会默认创建xx.db 文件
 @return NXDataBase实例
 */
+ (instancetype)nx_databaseWithPath:(NSString *)dbPath;

/**
 往数据库中增加一条数据<不开启事务>
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名
 @param obj <需要遵守NXDBObjectProtocol>
 @return YES/NO
 */
- (BOOL)nx_addObject:(id<NXDBObjectProtocol>)obj;
- (BOOL)nx_addObject:(id<NXDBObjectProtocol>)obj WithTableName:(NSString*)tableName;

/**
 往数据库中增加一组数据<不开启事务>
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名
 @param objs <数组中模型需要遵守NXDBObjectProtocol>
 @return YES/NO
 */
- (BOOL)nx_addObjects:(NSArray*)objs;
- (BOOL)nx_addObjects:(NSArray*)objs WithTableName:(NSString*)tableName;

/**
 往数据库中增加一组数据,开始事务.

 @param objs objs <数组中模型需要遵守NXDBObjectProtocol>
 @param tableName 数据表名,传nil则默认表明为类名
 @return YES/NO
 */
- (BOOL)nx_addObjectsInTransaction:(NSArray*)objs WithTableName:(NSString*)tableName;

/**
 从数据库中删除一条(组)数据
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名

 @param obj <需要遵守NXDBObjectProtocol>
 @return YES/NO
 */
- (BOOL)nx_deleteObject:(id<NXDBObjectProtocol>)obj;
- (BOOL)nx_deleteObject:(id<NXDBObjectProtocol>)obj withTableName:(NSString *)tableName;
- (BOOL)nx_deleteObjects:(NSArray<id<NXDBObjectProtocol>>*)objs;
- (BOOL)nx_deleteObjects:(NSArray<id<NXDBObjectProtocol>>*)objs withTableName:(NSString*)tableName;


/**
 更新数据
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名.
 @param clazz 需要更新的模型Class
 @param keyValues 需要更新的字段键值对 <key:属性名 value:需要更新的值>
 @param predicateFormat 格式化查询条件.
 @example:[...xxxcond:@"dataID = '%@ AND id=%d'",dataID, id]
 @return YES/NO
 */
- (BOOL)nx_updateObjectClazz:(Class)clazz keyValues:(NSDictionary *)keyValues cond:(NSString *)predicateFormat,...;
- (BOOL)nx_updateTableName:(NSString*)tableName objectClazz:(Class)clazz keyValues:(NSDictionary *)keyValues cond:(NSString *)predicateFormat,...;

/**
 获取数据表中的全部数据
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名.
 @param clazz 需要查询的模型Class
 @return class表的全部数据
 */
- (NSArray*)nx_getAllObjectsWithClass:(Class)clazz;
- (NSArray*)nx_getAllObjectsWithClass:(Class)clazz withTableName:(NSString*)tableName;

/**
 根据condition获取数据表中符合条件的数据
 @breif:使用第一种或者不传tableName 则默认使用类名作为表名.
 @param clazz 需要查询的模型Class
 @param predicateFormat 格式化查询条件.
 orderName 排序的propertyName 降序 需要在propertyName后拼接 'desc'
 limit 传0无限制.
 CustomCond:默认不拼接'where',condition 自定义 "where dataID='AAA' order by dataID limit 10"
 @example:[...xxxcond:@"dataID = '%@ AND id=%d'",dataID, id]
 @return 数据表中符合条件的所有数据集合
 */
- (NSArray *)nx_getObjectsWithClass:(Class)clazz whereCond:(NSString *)predicateFormat, ...;
- (NSArray *)nx_getObjectsWithClass:(Class)clazz withTableName:(NSString*)tableName whereCond:(NSString *)predicateFormat, ...;
- (NSArray *)nx_getObjectsWithClass:(Class)clazz withTableName:(NSString*)tableName customCond:(NSString *)predicateFormat, ...;
- (NSArray *)nx_getObjectsWithClass:(Class)clazz withTableName:(NSString*)tableName orderBy:(NSString*)orderName limit:(NSInteger)count cond:(NSString *)predicateFormat, ...;

/**
 根据condition 获取数据表中符合条件的数据集合,直接返回字典数据

 @param tableName 表名
 @param predicateFormat 查询条件.如果传'nil'查询全部
 @return 返回字典数组.
 */
- (NSArray *)nx_getResultDictionaryWithTableName:(NSString*)tableName customCond:(NSString *)predicateFormat, ...;

/**
 根据condition获取数据表中数据的个数
 @breif:不传tableName 则默认使用类名作为表名.
 @param clazz 需要查询的模型Class
 @param predicateFormat 格式化查询条件.
 @example:[...xxxcond:@"dataID = '%@ AND id=%d'",dataID, 12]
 @return 数据表中符合条件的数据的个数
 */
- (long)nx_countInDataBaseWithClass:(Class)clazz withTableName:(NSString*)tableName cond:(NSString*)predicateFormat, ...;

/**
 删除数据表

 @param clazz 如果表名为class 可使用第一种
 @return 执行结果
 */
- (BOOL)nx_removeTableWithClass:(Class)clazz;

/**
 删除数据表

 @param table_name 表名
 @return 执行结果
 */
- (BOOL)nx_removeTable:(NSString*)table_name;

/*
 当某个数据库中的一个或多个数据表存在大量的插入、更新和删除等操作时，将会有大量的磁盘空间被已删除的数据所占用，在没有执行VACUUM命令之前，SQLite并没有将它们归还于操作系统。由于该类数据表中的数据存储非常分散，因此在查询时，无法得到更好的批量IO读取效果，从而影响了查询效率。

 在SQLite中，仅支持清理当前连接中的主数据库，而不能清理其它Attached数据库。VACUUM命令在完成数据清理时采用了和PostgreSQL相同的策略，即创建一个和当前数据库文件相同大小的新数据库文件，之后再将该数据库文件中的数据有组织的导入到新文件中，其中已经删除的数据块将不会被导入，在完成导入后，收缩新数据库文件的尺寸到适当的大小
 */
- (BOOL)nx_vacuumDB;

#pragma mark - condition Method
- (instancetype)nx_selectClazz:(Class)clazz;
- (instancetype)nx_selectTableName:(NSString*)tableName;
- (instancetype)nx_whereProperty:(NSString*)propertyName;
- (instancetype)nx_andProperty:(NSString*)propertyName;
- (instancetype)nx_equal:(id)value;
- (instancetype)nx_equalMore:(NSInteger)value;
- (instancetype)nx_equalLess:(NSInteger)value;
- (instancetype)nx_more:(NSInteger)value;
- (instancetype)nx_less:(NSInteger)value;
- (instancetype)nx_orderby:(NSString*)propertyName asc:(BOOL)asc;
- (instancetype)nx_limit:(int)count;
- (NSArray*)nx_queryObjectsWithClazz:(Class)clazz;

@end
