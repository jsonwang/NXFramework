//
//  NXAutoPrimaryKeyModel.m
//  NXDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXAutoPrimaryKeyModel.h"

@implementation NXAutoPrimaryKeyModel
NXDB_IMPLEMENTATION_INJECT(NXAutoPrimaryKeyModel)

- (void)nx_setValue:(id)value forUndefinedKey:(NSString *)key
{
 
}
@end
