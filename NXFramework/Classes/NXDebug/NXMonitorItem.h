//
//  QYMonitorItem.h
//  MonitorTool
//
//  Created by liuming on 16/9/30.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXMonitorItem : UIView

@property(nonatomic, assign, readonly) double width;
@property(nonatomic, assign, readonly) double height;

- (void)setTitleString:(NSString *)titleString;
- (void)setDataString:(NSString *)dataString;
@end
