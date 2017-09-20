//
//  NXBrowseViewPage.m
//  ZhongTouBang
//
//  Created by AK on 8/13/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXBrowseViewPage.h"

@interface NXBrowseViewPage ()

@property(nonatomic, strong) NXView *contentView;

@property(nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation NXBrowseViewPage

#pragma mark - Init Method

- (void)initialize
{
    _contentView = [[NXView alloc] initWithFrame:self.bounds];
    _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:_contentView];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

@end
