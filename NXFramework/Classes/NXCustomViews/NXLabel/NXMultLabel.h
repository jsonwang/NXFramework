//
//  NXMultLabel.h
//  NXLib
//
//  Created by AK on 14-3-7.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/*

  use demo
 NSMutableArray* setArray_f = [[NSMutableArray alloc] initWithCapacity:5];
 [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor
 blackColor],@"Color",[UIFont
 systemFontOfSize:14],@"Font",nil]];

 [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor
 blueColor],@"Color",[UIFont
 systemFontOfSize:14],@"Font",nil]];

 MultiTextView* showLable = [[MultiTextView alloc]
 initWithFrame:CGRectMake(init_x,init_y,320,30)];
 showLable.alignmentType = Muti_Alignment_Mid_Type;
 //    [showLable setBackgroundColor:[UIColor yellowColor]];
 [showLable setShowText:@"你申请的账号:|1007" Setting:setArray_f];
 [self.view addSubview:showLable];
 [showLable release];
 */

#import "NXLineLabel.h"

/*
 本类的作用：
 显示不同类型的字符串［字体大小、颜色等等］
 @1.0:目前只支持在同一行显示
 */

typedef enum _MutiTextAlignmentType {
    Muti_Alignment_Left_Type = 0x20,
    Muti_Alignment_Mid_Type = 0x21,
    Muti_Alignment_Right_Type = 0x22,
} MutiTextAlignmentType;

@interface NXMultLabel : UIView

@property(nonatomic) MutiTextAlignmentType alignmentType;

/*
 @text : 要显示的分割字符，以｜号隔开 ps:xxx|xxx|xxx
 @setDictionary:每个字符的设置项目 [NSDictionary]
 Color:[字体的颜色]
 Font:[字体的大小]
 */
- (void)setShowText:(NSString *)text Setting:(NSArray *)setDictionary;

@end
