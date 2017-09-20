//
//  NXExpandTableViewCell.h
//  NXlib
//
//  Created by AK on 4/29/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXTableViewCell.h"

@interface NXExpandTableViewCell : NXTableViewCell

/**
 * The boolean value showing the receiver is expandable or not.
 * The default value of this property is NO.
 */
@property(nonatomic, assign, getter=isExpandable) BOOL expandable;

/**
 * The boolean value showing the receiver is expanded or not.
 * The default value of this property is NO.
 */
@property(nonatomic, assign, getter=isExpanded) BOOL expanded;

@end
