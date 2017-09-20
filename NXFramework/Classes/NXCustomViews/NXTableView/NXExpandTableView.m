//
//  NXExpandTableView.m
//  NXlib
//
//  Created by AK on 4/29/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXExpandTableView.h"
#import <objc/runtime.h>

#import "NXExpandTableViewCell.h"

#pragma mark - NSArray (NXExpandTableView)

@interface NSMutableArray (NXExpandTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (SKSTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems
{
    for (NSInteger index = [self count]; index < numItems; index++)
    {
        NSMutableArray *array = [NSMutableArray array];
        [self addObject:array];
    }
}

@end

#pragma mark - NXExpandTableView

@interface NXExpandTableView ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *expandedIndexPaths;

@property(nonatomic, strong) NSMutableDictionary *expandableCells;

@end

@implementation NXExpandTableView

- (BOOL)isExpandedForCellAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL expanded = NO;
    return expanded;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 0; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 0; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ExpandCell";
    NXExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[NXExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end

#pragma mark - NSIndexPath (NXExpandTableView)

static void *SCFWNSIndexPathSubRowObjectKey;

@implementation NSIndexPath (NXExpandTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id subRowObj = objc_getAssociatedObject(self, SCFWNSIndexPathSubRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SCFWNSIndexPathSubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    return indexPath;
}

@end
