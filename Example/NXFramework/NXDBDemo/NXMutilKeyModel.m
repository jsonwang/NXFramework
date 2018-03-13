//
//  GMutilKeyModel.m
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXMutilKeyModel.h"

@implementation NXMutilKeyModel

NXDB_IMPLEMENTATION_INJECT(NXMutilKeyModel)

- (NSArray<NSString *> *)nx_customPrimarykey
{
    return @[@"primaryKey1",@"primaryKey2",@"primaryKey3"];
}
@end
