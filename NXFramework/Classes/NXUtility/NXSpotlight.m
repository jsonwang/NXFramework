//
//  NXSpotlight.m
//  NXlib
//
//  Created by AK on 16/4/26.
//  Copyright © 2016年 AK. All rights reserved.
//

#import "NXSpotlight.h"
@import CoreSpotlight;
@import MobileCoreServices;

#import "NXSystemInfo.h"

@implementation NXSpotlight

+ (void)createSearchIndex:(NSArray *)dataSources
{
    NSMutableArray *searchItems = [[NSMutableArray alloc] init];
    [dataSources enumerateObjectsUsingBlock:^(CSSearchableItemAttributeSet *_Nonnull attributeSet, NSUInteger idx,
                                              BOOL *_Nonnull stop) {

        //开启显示电话按钮，若phoneNumbers为空，则开启了该权限也不会显示电话按钮
        attributeSet.supportsPhoneCall = @(YES);

        //这里的UniqueIdentifier的值 在点击后通过kCSSearchableItemActivityIdentifier
        // KEY 可以取成,如设置vid=5200&uid=1000 为跳转界面使用
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:attributeSet.contentType
                                                                   domainIdentifier:[NXSystemInfo bundleID]
                                                                       attributeSet:attributeSet];
        [searchItems addObject:item];
    }];

    // XXXX:索引的创建及删除都是在一个子线程里
    // 在子线程里也就说明我们无法控制其执行的先后顺序
    [[CSSearchableIndex defaultSearchableIndex]
        deleteAllSearchableItemsWithCompletionHandler:^(NSError *_Nullable error) {

            if (!error)
            {
                NSLog(@"删除索引完成");
                [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchItems
                                                               completionHandler:^(NSError *_Nullable error) {

                                                                   if (!error)
                                                                   {
                                                                       NSLog(@"创建索引完成");
                                                                   }
                                                                   else
                                                                   {
                                                                       NSLog(@"创建索引失败");
                                                                   }

                                                               }];
            }
            else
            {
                NSLog(@"删除索引失败 %@", error.localizedDescription);
            }

        }];
}

/*
有三种方式来删除检索入口，分别是根据uniqueID，domain以及删除所有入口

[[CSSearchableIndex defaultSearchableIndex]
deleteSearchableItemsWithIdentifiers:[NSArray
arrayWithObjects:@"apple-001", @"apple-002", nil nil]
completionHandler:^(NSError * _Nullable error) {
        if (!error) {
                NSLog(@"Items deleted");
        }
}];

[[CSSearchableIndex defaultSearchableIndex]
deleteSearchableItemsWithDomainIdentifiers:[NSArray
arrayWithObjects:@"xxx.fruit.com", nil nil] completionHandler:^(NSError *
_Nullable error) {
        if (!error) {
                NSLog(@"Items deleted");
        }
}];

[[CSSearchableIndex defaultSearchableIndex]
deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error)
{
        if (!error) {
                NSLog(@"All items deleted");
        }
}];
 */

@end
