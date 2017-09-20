//
//  ItemModel.m
//  MonitorTool
//
//  Created by liuming on 16/11/11.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXDMItemModel.h"

@implementation NXDMItemModel

@end

NXDMItemModel *newModel(NSString *title, NSString *data, BOOL canClicked, QYMonitorCategory category)
{
    NXDMItemModel *model = [[NXDMItemModel alloc] init];
    model.data = data;
    model.title = title;
    model.canClicked = canClicked;
    model.category = category;
    return model;
}
