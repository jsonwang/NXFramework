//
//  NXBrowseViewPage.h
//  ZhongTouBang
//
//  Created by AK on 8/13/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXView.h"

@class NXBrowseViewPage;

@interface NXBrowseViewPage : NXView

@property(nonatomic, readonly, strong) NXView *contentView;

@property(nonatomic, readonly, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
