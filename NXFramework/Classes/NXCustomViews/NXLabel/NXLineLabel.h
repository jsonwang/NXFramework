//
//  NXLineLabel.h
//  NXLib
//
//  Created by AK on 14-3-7.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/*
         e.g.
     NXLineLabel * lineLabel = [[NXLineLabel alloc] initWithFrame:CGRectMake(10,
   100, 100, 20)];
     lineLabel.text = @"这是一个有下划线的";
     [lineLabel setBackgroundColor:[UIColor clearColor]];
     [lineLabel setTextColor:[UIColor blackColor]];
     lineLabel.lineType = LineTypeDown;
     [self.view addSubview:lineLabel];
 */

#import <UIKit/UIKit.h>

typedef enum {

    LineTypeNone,
    LineTypeUp,
    LineTypeMiddle,
    LineTypeDown,

} LineType;

@interface NXLineLabel : UILabel
{
}

@property(assign, nonatomic) LineType lineType;
@property(assign, nonatomic) UIColor *lineColor;

@end
