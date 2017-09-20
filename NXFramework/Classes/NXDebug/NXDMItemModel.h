//
//  ItemModel.h
//  MonitorTool
//
//  Created by liuming on 16/11/11.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, QYMonitorCategory) {
    NXMonitorCategoryOfFPS,
    NXMonitorCategoryOfCPU,
    NXMonitorCategoryOfMemory,
    NXMonitorCategoryOfCountry,
    NXMonitorCategoryOfLanguage,
    NXMonitorCategoryOfLogs,
    NXMonitorCategoryOfSandbox,
    NXMonitorCategoryOfSoundID,
    
    NXMonitorCategoryOfCustom
    
};
@interface NXDMItemModel : NSObject

@property(nonatomic, strong) NSString *data;              ///< 显示的数据
@property(nonatomic, assign) BOOL canClicked;             ///< 是否可点击
@property(nonatomic, strong) NSString *title;             ///< 标题
@property(nonatomic, assign) QYMonitorCategory category;  ///< 类型
@end

/**
  创建MODEL 数据源

 @param data 要显示的数据
 @param title 标题
 @param canClicked 是否可点击
 @param category 数据类型
 @return 返回MODEL
 */
NXDMItemModel *newModel(NSString *data, NSString *title, BOOL canClicked, QYMonitorCategory category);
