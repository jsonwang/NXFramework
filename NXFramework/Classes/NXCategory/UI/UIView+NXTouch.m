//
//  UIView+NXTouch.m
//  NXSpringViewDemo
//
//  Created by 陈方方 on 2017/3/23.
//  Copyright © 2017年 陈方方. All rights reserved.
//

#import "UIView+NXTouch.h"
#import "objc/runtime.h"


static const char *UITableViewCell_acceptEventInterval = "UITableViewCell_acceptEventInterval";
static const char *UITableViewCell_ignoreEvent = "UITableViewCell_ignoreEvent";

@implementation UIView (NXTouch)

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(gestureRecognizerShouldBegin:));
    Method b = class_getInstanceMethod(self, @selector(__nx_gestureRecognizerShouldBegin:));
    
    //改变两个方法的实现
    method_exchangeImplementations(a, b);
}

- (NSTimeInterval)nx_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UITableViewCell_acceptEventInterval) doubleValue];
}

- (void)setNx_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UITableViewCell_acceptEventInterval, @(uxy_acceptEventInterval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent
{
    objc_setAssociatedObject(self, UITableViewCell_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ignoreEvent { return [objc_getAssociatedObject(self, UITableViewCell_ignoreEvent) boolValue]; }


- (BOOL)__nx_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.ignoreEvent)
    {
        NSLog(@"无效点击!!!!!!!!!!");
        return NO;
    }
    if (self.nx_acceptEventInterval > 0)
    {
        self.ignoreEvent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.nx_acceptEventInterval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.ignoreEvent = NO;
                       });
    }
    //调用系统实现
    return   [self __nx_gestureRecognizerShouldBegin:gestureRecognizer];
}
@end
