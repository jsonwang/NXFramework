//
//  NXAppsDataViewModel.m
//  GOACloud
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXAppsDataViewModel.h"

@implementation NXAppsDataViewModel
NXDB_IMPLEMENTATION_INJECT(NXAppsDataViewModel)

- (NSArray<NSString *> *)nx_customPrimarykey
{
    return @[@"dataID"];
}


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"dataID" :@"id",
             @"dataGroup" : @"group",
             @"dataIndex" :@"index",
             @"templateID" : @"template",
             };
}

@end
