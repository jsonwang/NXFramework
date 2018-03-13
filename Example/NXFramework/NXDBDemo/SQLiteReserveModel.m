//
//  SQLiteReserveModel.m
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "SQLiteReserveModel.h"

@implementation SQLiteReserveModel
NXDB_IMPLEMENTATION_INJECT(SQLiteReserveModel)

- (NSArray<NSString *> *)nx_customPrimaryKey
{
    return @[@"index"];
}

@end
