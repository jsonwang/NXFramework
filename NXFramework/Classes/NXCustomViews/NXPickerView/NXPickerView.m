//
//  NXPickerView.m
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXPickerView.h"
#import "NSArray+NXCategory.h"
#import "NXToolbar.h"

#import "UIView+NXCategory.h"

@interface NXPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource, NXToolbarActionDelegate>

/// 工具条
@property(nonatomic, strong) NXToolbar *toolbar;

/// 选择器
@property(nonatomic, strong) UIPickerView *pickerView;

/// 完成回调
@property(nonatomic, copy) NXPickerViewDoneHandler doneHandler;

/// 取消回调
@property(nonatomic, copy) NXPickerViewCancelHandler cancelHandler;

@end

@implementation NXPickerView

#pragma mark - Init Method

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(NX_MAIN_SCREEN_HEIGHT, NX_TOOLBAR_HEIGHT + NX_PICKERVIEW_HEIGHT);
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.actionAnimations = NXViewActionAnimationActionSheet;

        _toolbar = [[NXToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, 0,self.nx_width, NX_TOOLBAR_HEIGHT);
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.actionStyle = NXToolbarActionStyleDoneAndCancel;
        _toolbar.actionDelegate = self;
        [self addSubview:_toolbar];

        _pickerView = [[UIPickerView alloc] init];
        _pickerView.nx_top = _toolbar.nx_bottom;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    return self;
}

- (id)initWithDataSources:(NSArray *)aDataSources
{
    if (self = [self initWithFrame:CGRectZero])
    {
        self.dataSources = aDataSources;
    }
    return self;
}

#pragma mark - Setter Method

- (void)setDataSources:(NSArray *)dataSources
{
    _dataSources = [dataSources copy];

    [_pickerView reloadAllComponents];
}

#pragma mark - NXToolbarActionDelegate

- (void)toolbarDidDone:(NXToolbar *)toolbar
{
    if (_doneHandler != nil)
    {
        NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
        id result = nil;
        if ([_dataSources nx_isNotEmpty] && [_dataSources count] > selectedRow)
        {
            result = [_dataSources objectAtIndex:selectedRow];
        }
        _doneHandler(result);
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

#pragma mark - UIPickerViewDelegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSources.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self titleForRow:row];
}

#pragma mark - Public Method

/**
 *  显示选择器
 *
 *  @param doneHandler   完成回调
 *  @param cancelHandler 取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(NXPickerViewDoneHandler)doneHandler
     cancelHandler:(NXPickerViewCancelHandler)cancelHandler
{
    self.doneHandler = doneHandler;
    self.cancelHandler = cancelHandler;

    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self showInView:view];
}

#pragma mark - Private Method

- (NSString *)titleForRow:(NSInteger)row
{
    NSString *rowTitle = @"";
    if (!_dataSources.nx_isNotEmpty || _dataSources.count <= row)
    {
        return rowTitle;
    }
    id anyObject = [_dataSources objectAtIndex:row];
    if ([anyObject isKindOfClass:[NSString class]])
    {
        rowTitle = [_dataSources objectAtIndex:row];
    }
    else if ([anyObject isKindOfClass:[NSDictionary class]])
    {
        rowTitle = [(NSDictionary *)anyObject objectForKey:_valueKey];
    }
    else if ([anyObject isKindOfClass:[NSObject class]])
    {
        rowTitle = [anyObject valueForKey:_valueKey];
    }
    return rowTitle;
}

@end
