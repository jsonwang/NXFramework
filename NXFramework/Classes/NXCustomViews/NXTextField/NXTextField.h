//
//  NXTextField.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTextField : UITextField

@property(nonatomic, strong) UIImage *leftImage;
@property(nonatomic, copy) NSString *leftText;

/**
  设置textfield的leftview

 @param leftText 文字
 @param font 字体
 */
- (void)setLeftText:(NSString *)leftText forFont:(UIFont *)font;

@end
