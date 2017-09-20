//
//  NXExpandTableView.h
//  NXlib
//
//  Created by AK on 4/29/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXTableView.h"

@protocol NXExpandTableViewDelegate;

@interface NXExpandTableView : NXTableView

@property(nonatomic, weak) id<NXExpandTableViewDelegate> expandDelegate;

@property(nonatomic, assign) BOOL shouldExpandOnlyOneCell;

- (BOOL)isExpandedForCellAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - NXExpandTableViewDelegate

@protocol NXExpandTableViewDelegate<UITableViewDataSource, UITableViewDelegate>

@required
- (NSInteger)tableView:(NXExpandTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(NXExpandTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)tableView:(NXExpandTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - NSIndexPath (NXExpandTableView)

@interface NSIndexPath (NXExpandTableView)

@property(nonatomic, assign) NSInteger subRow;

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;

@end
