//
//  QYMonitorView.h
//  MonitorTool
//
//  Created by liuming on 16/9/29.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXMonitorTool.h"
#import <UIKit/UIKit.h>
@interface NXMonitorView : UIView

- (instancetype)initWithCustomArr:(NSArray<NXDMItemModel *> *)customArr;
- (void)showToWindow:(UIView *)superView;
@end

@interface QYMOnitorCustView : UIView

@property(nonatomic, strong) NSArray<NXDMItemModel *> *moreArr;  ///< 更多信息

- (void)refreshData:(NSArray<NXDMItemModel *> *)moreArr;
@end
