//
//  UIControl+acceptEventInterval.m
//  NXlib
//
//  Created by AK on 15/9/15.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "UIControl+NXCategory.h"

#if TARGET_OS_IPHONE
#import <objc/message.h>
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

@implementation UIControl (NXCategory)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";

//改变两个方法的实现。在类第一次使用的时候回调用这个方法
+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    //改变两个方法的实现
    method_exchangeImplementations(a, b);  // isnt
}
//通过关联对象重写get和set方法
- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark 现在是否可点的get和set。通过关联对象。
- (void)setIgnoreEvent:(BOOL)ignoreEvent
{
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ignoreEvent { return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue]; }
- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.ignoreEvent)
    {
        NSLog(@"无效点击!!!!!!!!!!");
        return;
    }
    if (self.uxy_acceptEventInterval > 0)
    {
        self.ignoreEvent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.uxy_acceptEventInterval * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.ignoreEvent = NO;
                       });
    }

    //调用系统实现
    [self __uxy_sendAction:action to:target forEvent:event];
}

@end
