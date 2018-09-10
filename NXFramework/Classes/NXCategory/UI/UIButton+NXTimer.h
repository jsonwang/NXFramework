//
//  UIButton+NXTimer.h
//  Pods
//
//  Created by AK on 2017/10/24.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (NXTimer)

/*
    e.g. 使用 btn 显示倒计时效果
 
     UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
     [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     btn.backgroundColor = [UIColor whiteColor];
     [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
     [btn setTitle:@"获取验证码" forState:UIControlStateNormal] ;
     [self.view addSubview:btn];
     
     ...........
     
     - (void)clickBtn:(UIButton *)btn
     {
     [btn startWithTime:2 title:btn.titleLabel.text countDownTitle:@"秒后重发" normalBackgroundColor:[UIColor whiteColor] selectedBackgroundColor:NX_UIColorFromRGB(0x959595)];
     }
 */

/**
 显示倒计时

 @param timeLine 时间长度 S
 @param title 默认文字
 @param titleColor 默认文字的颜色
 @param subTitle 开始时文字
 @param mColor 默认背景色
 @param color 开始时背景色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title titleColor:(UIColor *)titleColor countDownTitle:(NSString *)subTitle normalBackgroundColor:(UIColor *)mColor selectedBackgroundColor:(UIColor *)color;


@end
