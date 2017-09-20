//
//  NXDBHelper.m
//  NXlib
//
//  Created by AK on 15/8/31.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NXDBHelper.h"

#import "NXFileManager.h"
//解决使用 POD 时 报错问题
#if FMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif


#import "FMDB.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7

#define NXDBWeak weak

#else

#define NXDBWeak unsafe_unretained

#endif

@interface NXDBWeakObject : NSObject
@property(NXDBWeak, nonatomic) NXDBHelper *obj;
@end

@interface NXDBHelper ()

@property(strong, nonatomic) NSMutableArray *createdTableNames;

@property(NXDBWeak, nonatomic) FMDatabase *usingdb;
@property(strong, nonatomic) FMDatabaseQueue *bindingQueue;
@property(copy, nonatomic) NSString *dbPath;

@property(strong, nonatomic) NSRecursiveLock *threadLock;
@end

@implementation NXDBHelper
+ (NSMutableArray *)dbHelperSingleArray
{
    static __strong NSMutableArray *dbArray;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dbArray = [NSMutableArray array];
    });
    return dbArray;
}

+ (NSString *)getDBPathWithDBName:(NSString *)dbName
{
    NSString *fileName = nil;

    if ([dbName hasSuffix:@".db"] == NO)
    {
        fileName = [NSString stringWithFormat:@"%@.db", dbName];
    }
    else
    {
        fileName = dbName;
    }

    NSString *filePath = [NXFileManager getPathForDocuments:fileName inDir:@"db"];
    return filePath;
}

+ (NXDBHelper *)dbHelperWithPath:(NSString *)dbFilePath save:(NXDBHelper *)helper
{
    NSMutableArray *dbArray = [self dbHelperSingleArray];
    NXDBHelper *instance = nil;
    @synchronized(dbArray)
    {
        if (helper)
        {
            NXDBWeakObject *weakObj = [[NXDBWeakObject alloc] init];
            weakObj.obj = helper;
            [dbArray addObject:weakObj];
        }
        else if (dbFilePath)
        {
            for (NSInteger i = 0; i < dbArray.count;)
            {
                NXDBWeakObject *weakObj = [dbArray objectAtIndex:i];

                if (weakObj.obj == nil)
                {
                    [dbArray removeObjectAtIndex:i];
                    continue;
                }
                else if ([weakObj.obj.dbPath isEqualToString:dbFilePath])
                {
                    instance = weakObj.obj;
                    break;
                }

                i++;
            }
        }
    }
    return instance;
}

- (instancetype)initWithDBName:(NSString *)dbname { return [self initWithDBName:@"LKDB"]; }
- (instancetype)initWithDBPath:(NSString *)filePath
{
    if (filePath.length == 0)
    {
        /// release self
        self = nil;
        return nil;
    }

    NXDBHelper *helper = [NXDBHelper dbHelperWithPath:filePath save:nil];

    if (helper)
    {
        self = helper;
    }
    else
    {
        self = [super init];

        if (self)
        {
            self.threadLock = [[NSRecursiveLock alloc] init];
            self.createdTableNames = [NSMutableArray array];

            [self setDBPath:filePath];
            [NXDBHelper dbHelperWithPath:nil save:self];
        }
    }

    return self;
}

- (void)setDBName:(NSString *)dbName { [self setDBPath:[NXDBHelper getDBPathWithDBName:dbName]]; }
- (void)setDBPath:(NSString *)filePath
{
    if (self.bindingQueue && [self.dbPath isEqualToString:filePath])
    {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建数据库目录
    NSRange lastComponent = [filePath rangeOfString:@"/" options:NSBackwardsSearch];

    if (lastComponent.length > 0)
    {
        NSString *dirPath = [filePath substringToIndex:lastComponent.location];
        BOOL isDir = NO;
        BOOL isCreated = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];

        if ((isCreated == NO) || (isDir == NO))
        {
            NSError *error = nil;
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            NSDictionary *attributes = @{NSFileProtectionKey : NSFileProtectionNone};
#else
            NSDictionary *attributes = nil;
#endif
            BOOL success = [fileManager createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:attributes
                                                        error:&error];

            if (success == NO)
            {
                NSLog(@"create dir error: %@", error.debugDescription);
            }
        }
        else
        {
/**
 *  @brief  Disk I/O error when device is locked
 *          https://github.com/ccgus/fmdb/issues/262
 */
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
            [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone } ofItemAtPath:dirPath error:nil];
#endif
        }
    }

    self.dbPath = filePath;
    [self.bindingQueue close];

#ifndef SQLITE_OPEN_FILEPROTECTION_NONE
#define SQLITE_OPEN_FILEPROTECTION_NONE 0x00400000
#endif

    self.bindingQueue = [[FMDatabaseQueue alloc]
        initWithPath:filePath
               flags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_NONE];
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager setAttributes:@{ NSFileProtectionKey : NSFileProtectionNone } ofItemAtPath:filePath error:nil];
    }
#endif

    _encryptionKey = nil;

#ifdef DEBUG
    // debug 模式下  打印错误日志
    [_bindingQueue inDatabase:^(FMDatabase *db) {
        db.logsErrors = YES;
    }];
#endif
}

#pragma mark - set key
- (void)setEncryptionKey:(NSString *)encryptionKey
{
    _encryptionKey = encryptionKey;

    if (_bindingQueue && (encryptionKey.length > 0))
    {
        [self executeDB:^(FMDatabase *db) {
            [db setKey:_encryptionKey];
        }];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    NSArray *array = [NXDBHelper dbHelperSingleArray];

    @synchronized(array)
    {
        for (NXDBWeakObject *weakObject in array)
        {
            if ([weakObject.obj isEqual:self])
            {
                weakObject.obj = nil;
            }
        }
    }

    [self.bindingQueue close];
    self.usingdb = nil;
    self.bindingQueue = nil;
    self.dbPath = nil;
    self.threadLock = nil;
}

#pragma mark - core
- (void)executeDB:(void (^)(FMDatabase *db))block
{
    [_threadLock lock];

    if (self.usingdb != nil)
    {
        block(self.usingdb);
    }
    else
    {
        if (_bindingQueue == nil)
        {
            self.bindingQueue = [[FMDatabaseQueue alloc] initWithPath:_dbPath];
            [_bindingQueue inDatabase:^(FMDatabase *db) {
#ifdef DEBUG
                // debug 模式下  打印错误日志
                db.logsErrors = YES;
#endif

                if (_encryptionKey.length > 0)
                {
                    [db setKey:_encryptionKey];
                }
            }];
        }

        [_bindingQueue inDatabase:^(FMDatabase *db) {
            self.usingdb = db;
            block(db);
            self.usingdb = nil;
        }];
    }

    [_threadLock unlock];
}

@end

@implementation NXDBWeakObject

@end
