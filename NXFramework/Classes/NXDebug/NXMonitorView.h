//
//  QYMonitorView.h
//  MonitorTool
//
//  Created by liuming on 16/9/29.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXMonitorTool.h"
#import <UIKit/UIKit.h>
#import "NXDataSyncMonitor.h"
@interface NXMonitorView : UIView

- (instancetype)initWithCustomArr:(NSArray<NXDMItemModel *> *)customArr;
- (void)showToWindow:(UIView *)superView;
- (void)dsEvent:(NSString *)event;
- (void)dsEvent:(NSString *)event level:(NXDataSyncEventLevel)level;
@end

@interface QYMOnitorCustView : UIView

@property(nonatomic, strong) NSArray<NXDMItemModel *> *moreArr;  ///< 更多信息

- (void)refreshData:(NSArray<NXDMItemModel *> *)moreArr;
@end
