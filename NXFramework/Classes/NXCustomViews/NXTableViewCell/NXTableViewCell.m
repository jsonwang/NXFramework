//
//  NXTableViewCell.m
//  NXlib
//
//  Created by AK on 3/11/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXTableViewCell.h"

@implementation NXTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
