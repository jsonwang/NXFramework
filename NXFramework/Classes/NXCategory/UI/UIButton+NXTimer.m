//
//  UIButton+NXTimer.m
//  Pods
//
//  Created by AK on 2017/10/24.
//
//

#import "UIButton+NXTimer.h"
#import "NXConfig.h"


@implementation UIButton (NXTimer)

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title titleColor:(UIColor *)titleColor countDownTitle:(NSString *)subTitle normalBackgroundColor:(UIColor *)mColor selectedBackgroundColor:(UIColor *)color;
{
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:NX_UIColorFromRGB(0x757575) forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }
        else
        {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                [self setTitleColor:NX_UIColorFromRGB(0x757575) forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
