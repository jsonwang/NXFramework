//
//  NXDBUtil.m
//  NXDB
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXDBUtil.h"
#import "NXDB.h"

@implementation NXDBUtil

+ (BOOL)isEmpty:(NSString *)string
{
    if (!string)
    {
        return YES;
    }
    else
    {
        if (![string isKindOfClass:[NSString class]])
        {
            return NO;
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

+ (NSString *)operationDescription:(NXDBOperation)op
{
    NSString *operationDesc = @"";
    switch (op)
    {
        case NXDBOperationCreate:
            operationDesc = @"插入";
            break;
        case NXDBOperationRead:
            operationDesc = @"读取";
            break;
        case NXDBOperationReadSync:
            operationDesc = @"同步读取";
            break;
        case NXDBOperationUpdate:
            operationDesc = @"更新";
            break;
        case NXDBOperationDelete:
            operationDesc = @"删除";
            break;
        default:
            break;
    }
    return operationDesc;
}

+ (Class)modelClass:(id)model
{
    if ([model isKindOfClass:[NSArray class]])
    {
        return [[model firstObject] class];
    }
    return [model class];
}

+ (NSString *)sqlConditionWithArray:(NSArray *)conditions
{
    NSMutableString *sqlCondition = [[NSMutableString alloc] init];
    [sqlCondition appendString:@"WHERE "];
    for (NXDBCondition *condition in conditions)
    {
        if (![condition isKindOfClass:[NXDBCondition class]])
        {
#ifndef NXDBLOGDISABLE
            NSLog(@"[SQL查询条件错误]");
#endif
            return @"";
        }
        [sqlCondition appendString:condition.property];
        NSString *compare = [NXDBUtil conditionOperator:condition.compare];
        NSString *value = [NSString stringWithFormat:@"'%@'", condition.value];
        if ([condition.compare isEqualToString:NXDBCONDITION_BETWEEN])
        {
            BOOL canApend = YES;
            NSArray *range = nil;
            if ([condition.value isKindOfClass:[NSArray class]])
            {
                range = condition.value;
            }
            else if ([condition.compare isKindOfClass:[NSString class]])
            {
                NSArray *range = [condition.compare componentsSeparatedByString:@"|"];
                if (range.count != 2)
                {
                    canApend = NO;
#ifndef NXDBLOGDISABLE
                    NSLog(@"[BETWEEN GRAMMAR ERROR!]");
#endif
                }
            }
            else
            {
                canApend = NO;
#ifndef NXDBLOGDISABLE
                NSLog(@"[BETWEEN PARAM ERROR!]");
#endif
            }
            if (canApend)
            {
                [sqlCondition appendString:compare];
                [sqlCondition appendString:range[0]];
                [sqlCondition appendString:@"AND"];
                [sqlCondition appendString:range[1]];
            }
        }
        else
        {
            [sqlCondition appendString:compare];
            [sqlCondition appendString:value];
        }
        if (![condition isEqual:[conditions lastObject]])
        {
            [sqlCondition appendString:@"AND "];
        }
    }
    return sqlCondition;
}

+ (NSString *)conditionOperator:(NSString *)op
{
    if ([NXDBUtil isEmpty:op]) return @"";
    if ([op isEqualToString:NXDBCONDITION_EQUAL])
    {
        return @"=";
    }
    if ([op isEqualToString:NXDBCONDITION_LESS])
    {
        return @"<";
    }
    if ([op isEqualToString:NXDBCONDITION_GREAT])
    {
        return @">";
    }
    if ([op isEqualToString:NXDBCONDITION_LESSTHAN])
    {
        return @"<=";
    }
    if ([op isEqualToString:NXDBCONDITION_GREATTHAN])
    {
        return @">=";
    }
    if ([op isEqualToString:NXDBCONDITION_UNEQUAL])
    {
        return @"!=";
    }
    if ([op isEqualToString:NXDBCONDITION_BETWEEN])
    {
        return @"BETWEEN";
    }
    if ([op isEqualToString:NXDBCONDITION_LIKE])
    {
        return @"LIKE";
    }
    return nil;
}

+ (NSString *)nx_database_version
{
    return [NSString stringWithFormat:@"nxdb_version_%@_%@", [[[NSBundle mainBundle] infoDictionary]
                                                                 objectForKey:@"CFBundleShortVersionString"],
                                      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

/**
 获取sqlite 保留字段集合

 @return NSDictionary
 */
+ (NSArray *)nx_sqliteReservedWords
{
    return @[
        @"ABORT",
        @"ACTION",
        @"ADD",
        @"AFTER",
        @"ALL",
        @"ALTER",
        @"ANALYZE",
        @"AND",
        @"AS",
        @"ASC",
        @"ATTACH",
        @"AUTOINCREMENT",
        @"BEFORE",
        @"BEGIN",
        @"BETWEEN",
        @"BY",
        @"CASCADE",
        @"CASE",
        @"CAST",
        @"CHECK",
        @"COLLATE",
        @"COLUMN",
        @"COMMIT",
        @"CONFLICT",
        @"CONSTRAINT",
        @"CREATE",
        @"CROSS",
        @"CURRENT_DATE",
        @"CURRENT_TIME",
        @"CURRENT_TIMESTAMP",
        @"DATABASE",
        @"DEFAULT",
        @"DEFERRABLE",
        @"DEFERRED",
        @"DELETE",
        @"DESC",
        @"DETACH",
        @"DISTINCT",
        @"DROP",
        @"EACH",
        @"ELSE",
        @"END",
        @"ESCAPE",
        @"EXCEPT",
        @"EXCLUSIVE",
        @"EXISTS",
        @"EXPLAIN",
        @"FAIL",
        @"FOR",
        @"FOREIGN",
        @"FROM",
        @"FULL",
        @"GLOB",
        @"GROUP",
        @"HAVING",
        @"IF",
        @"IGNORE",
        @"IMMEDIATE",
        @"IN",
        @"INDEX",
        @"INDEXED",
        @"INITIALLY",
        @"INNER",
        @"INSERT",
        @"INSTEAD",
        @"INTERSECT",
        @"INTO",
        @"IS",
        @"ISNULL",
        @"JOIN",
        @"KEY",
        @"LEFT",
        @"LIKE",
        @"LIMIT",
        @"MATCH",
        @"NATURAL",
        @"NO",
        @"NOT",
        @"NOTNULL",
        @"NULL",
        @"OF",
        @"OFFSET",
        @"ON",
        @"OR",
        @"ORDER",
        @"OUTER",
        @"PLAN",
        @"PRAGMA",
        @"PRIMARY",
        @"QUERY",
        @"RAISE",
        @"RECURSIVE",
        @"REFERENCES",
        @"REGEXP",
        @"REINDEX",
        @"RELEASE",
        @"RENAME",
        @"REPLACE",
        @"RESTRICT",
        @"RIGHT",
        @"TO",
        @"ROLLBACK",
        @"SAVEPOINT",
        @"SELECT",
        @"SET",
        @"TABLE",
        @"TEMP",
        @"TEMPORARY",
        @"THEN",
        @"TRANSACTION",
        @"TRIGGER",
        @"UNION",
        @"UNIQUE",
        @"UPDATE",
        @"USING",
        @"VACUUM",
        @"VALUES",
        @"VIEW",
        @"VIRTUAL",
        @"WHEN",
        @"WHERE",
        @"WITH",
        @"WITHOU",
    ];
}

@end
