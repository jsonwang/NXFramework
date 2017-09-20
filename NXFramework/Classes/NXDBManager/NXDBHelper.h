//
//  NXDBHelper.h
//  NXlib
//
//  Created by AK on 15/8/31.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXDBHelper : NSObject

/**
 *  根据数据库名 取到 数据库沙盒内路径
 *
 *  @param dbName 数据库名
 *
 *  @return 数据库全路径
 */
+ (NSString *)getDBPathWithDBName:(NSString *)dbName;
/**
 *  初始化方法
 *
 *  @param dbname filepath the use of : "documents/db/" + fileName + ".db"
 *
 *  @return 类对象
 */
- (instancetype)initWithDBName:(NSString *)dbname;
- (void)setDBName:(NSString *)fileName;

/**
 *	@brief  path of database file
 *  refer:  FMDatabase.h  + (instancetype)databaseWithPath:(NSString*)inPath;
 */
- (instancetype)initWithDBPath:(NSString *)filePath;
- (void)setDBPath:(NSString *)filePath;

/**
 *  @brief set and save encryption key.
 *  refer: FMDatabase.h  - (BOOL)setKey:(NSString*)key;
 */
@property(strong, nonatomic) NSString *encryptionKey;

@end
