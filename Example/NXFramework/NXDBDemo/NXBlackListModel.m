//
//  GBlackListModel.m
//  GDataBaseExample
//
//  Created by ꧁༺ Yuri ༒ Boyka™ ༻꧂ on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXBlackListModel.h"

@implementation NXBlackListModel

NXDB_IMPLEMENTATION_INJECT(NXBlackListModel)

- (NSArray<NSString *> *)nx_customPrimarykey
{
    return @[@"dataID"];
}

- (NSDictionary<NSString *,NSString *> *)nx_blackList
{
    return @{
             @"blackField1" :@"value",
             @"blackField2" :@"value",
             @"blackField3" :@"value",
             };
}
@end
