//
//  NXTextField.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXTextField.h"

@implementation NXTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method

- (void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;

    UIImageView *leftView = [[UIImageView alloc] initWithImage:leftImage];
    leftView.contentMode = UIViewContentModeCenter;
    self.leftView = leftView;
}

- (void)setLeftText:(NSString *)leftText
{
    _leftText = [leftText copy];

    UILabel *leftView = [[UILabel alloc] init];
    leftView.text = leftText;
    [leftView sizeToFit];
    self.leftView = leftView;
}

- (void)setLeftText:(NSString *)leftText forFont:(UIFont *)font
{
    _leftText = [leftText copy];

    UILabel *leftView = [[UILabel alloc] init];
    leftView.text = leftText;
    leftView.font = font;
    [leftView sizeToFit];
    self.leftView = leftView;
}

@end
