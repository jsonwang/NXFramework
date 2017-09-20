//
//  NXPickerView.h
//  NXlib
//
//  Created by AK on 3/6/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NXActionView.h"

#import "NXConfig.h"

typedef void (^NXPickerViewDoneHandler)(id result);
typedef void (^NXPickerViewCancelHandler)(void);

@interface NXPickerView : NXActionView

/// 数据源(字符串/字典/数据对象)
@property(nonatomic, copy) NSArray *dataSources;

/// 数据值对应的键(在"字典/数据对象"中对应的键)
@property(nonatomic, copy) NSString *valueKey;

- (id)initWithDataSources:(NSArray *)aDataSources;

/**
 *  显示选择器
 *
 *  @param doneHandler   完成回调
 *  @param cancelHandler 取消回调
 */
- (void)showInView:(UIView *)view
       doneHandler:(NXPickerViewDoneHandler)doneHandler
     cancelHandler:(NXPickerViewCancelHandler)cancelHandler;

@end
