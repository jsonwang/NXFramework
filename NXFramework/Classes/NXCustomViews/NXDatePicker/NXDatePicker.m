//
//  NXDatePicker.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXDatePicker.h"
#import "NXToolbar.h"

#import "NSDate+NXCategory.h"
#import "NXConfig.h"
#import "SDAutoLayout.h"

@interface NXDatePicker ()<NXToolbarActionDelegate>

/// 工具条
@property(nonatomic, strong) NXToolbar *toolbar;

/// 时间选择器
@property(nonatomic, strong) UIDatePicker *datePicker;

/// 完成回调
@property(nonatomic, copy) NXDatePickerDoneHandler doneHandler;

/// 取消回调
@property(nonatomic, copy) NXDatePickerCancelHandler cancelHandler;

@end

@implementation NXDatePicker

#pragma mark - Init Method

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(NX_MAIN_SCREEN_WIDTH, NX_TOOLBAR_HEIGHT + NX_DATEPICKER_HEIGHT);

    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.actionAnimations = NXViewActionAnimationActionSheet;

        _toolbar = [[NXToolbar alloc] init];
        _toolbar.size = CGSizeMake(self.width, NX_TOOLBAR_HEIGHT);
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.actionStyle = NXToolbarActionStyleDoneAndCancel;
        _toolbar.actionDelegate = self;
        [self addSubview:_toolbar];

        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.top = _toolbar.bottom;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(kNXFW_SECOND_YEAR * 30)];
        [self addSubview:_datePicker];
    }
    return self;
}

/**
 *  @brief 初始化
 *
 *  @param date 选中的时间
 */
- (id)initWithDate:(NSDate *)date
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        _datePicker.date = date;
    }
    return self;
}

#pragma mark - NXToolbarActionDelegate

- (void)toolbarDidDone:(NXToolbar *)toolbar
{
    if (_doneHandler != nil)
    {
        _doneHandler(_datePicker.date);
    }
    [self dismiss];
}

- (void)toolbarDidCancel:(NXToolbar *)toolbar
{
    if (_cancelHandler != nil)
    {
        _cancelHandler();
    }
    [self dismiss];
}

#pragma mark - Public Method

/**
 *  显示日期选择器
 *
 *  @param doneHandler   完成回调
 *  @param cancelHandler 取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(NXDatePickerDoneHandler)doneHandler
     cancelHandler:(NXDatePickerCancelHandler)cancelHandler
{
    self.doneHandler = doneHandler;
    self.cancelHandler = cancelHandler;

    [self datePicker].date = (_defaultDate ? _defaultDate : [NSDate date]);
    [self showInView:view];
}

@end
