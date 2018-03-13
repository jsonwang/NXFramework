//
//  GTableA.m
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NXTableA.h"

@implementation NXSubTableA

@end

@implementation NXTableA

NXDB_IMPLEMENTATION_INJECT(NXTableA)


- (id)nx_archiveProperty:(NSString*)property_name
{
    if ([property_name isEqualToString:@"datas"]) {
        NSData *data = [self.datas yy_modelToJSONData];
        return data;
    }
    return nil;
}

- (void)nx_unarchiveSetData:(id)data property:(NSString*)property_name
{
    if ([property_name isEqualToString:@"datas"]) {
        NSError *eror = nil;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&eror];
        self.datas = [NSArray yy_modelArrayWithClass:[NXSubTableA class] json:array];
    }
    
}

+ (NSDictionary<NSString *,NSString*> *)nx_customArchiveList
{
    return @{
             @"datas" : NXDATA_TEXT,
             @"data"  : NXDATA_BLOB,
             };
}

@end
