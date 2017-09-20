//
//  NXDatePicker.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXActionView.h"

typedef void (^NXDatePickerDoneHandler)(NSDate *date);
typedef void (^NXDatePickerCancelHandler)(void);

@interface NXDatePicker : NXActionView

/// 时间选择器
@property(nonatomic, strong, readonly) UIDatePicker *datePicker;

/// 默认显示日期
@property(nonatomic, strong) NSDate *defaultDate;

- (id)initWithDate:(NSDate *)date;

/*
 * 显示datepicker
 * @param view 父视图
 * @param doneHandler 点击确认回调
 * @param cancelHandler 点击取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(NXDatePickerDoneHandler)doneHandler
     cancelHandler:(NXDatePickerCancelHandler)cancelHandler;

@end
