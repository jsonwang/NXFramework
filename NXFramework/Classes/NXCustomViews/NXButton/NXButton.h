//
//  SCButton.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
   实现在button 中
   文字和图片上下左右混排效果,效果地址:http://jsonwang.github.io/images/nxbutton.jpeg

    e.g.
     NXButton * searchBtn = [NXButton buttonWithType:UIButtonTypeCustom];
     [searchBtn setImage:[UIImage imageNamed:@"album_disabled"]
   forState:UIControlStateNormal];
     [searchBtn setTitle:@"搜索按钮图片在左边" forState:UIControlStateNormal];
     searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
     [searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     [searchBtn setTitleColor:[UIColor orangeColor]
   forState:UIControlStateHighlighted];
     searchBtn.imageRect = CGRectMake(10, 10, 20, 20);
     searchBtn.titleRect = CGRectMake(35, 10, 120, 20);
     searchBtn.frame = CGRectMake(NX_MAIN_SCREEN_WIDTH * 0.5 - 80, 250, 160, 40);
     searchBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:242/255.0
   blue:210/255.0 alpha:1];
     [self.view addSubview:searchBtn];

 */
@interface NXButton : UIButton
{
}

/**
   文字坐标和区域
 */
@property(nonatomic, assign) CGRect titleRect;
/**
   图片坐标和区域
 */
@property(nonatomic, assign) CGRect imageRect;
@end
