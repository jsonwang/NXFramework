//
//  NXTextView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXTextView : UITextView

@property(nonatomic, assign) BOOL endEditingWhenSlide;

@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, strong) UIColor *placeholderColor;

/**
 清空当前文字 恢复初始状态
 */
- (void)reset;

@end
