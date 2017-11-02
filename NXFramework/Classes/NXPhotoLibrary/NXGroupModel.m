//
//  NXGroupModel.m
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#import "NXGroupModel.h"
#import "NXAssetModel.h"
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
#import <Photos/Photos.h>
#endif
@implementation NXGroupModel

- (id)copyWithZone:(nullable NSZone *)zone
{
    NXGroupModel *groupModel = [[self class] allocWithZone:zone];
    groupModel.collection = self.collection;
    groupModel.count = self.count;
    return groupModel;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    NXGroupModel *groupModel = [[[self class] alloc] init];
    groupModel.collection = self.collection;
    groupModel.count = self.count;
    return groupModel;
}
@end
