//
//  UIViewController+addiction.h
//  YOYO
//
//  Created by 王 成 on 8/1/14.
//  Copyright (c) 2014 yoyo-corp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NXAddiction)

/*
 * 自定义navigationbar 的标题
 *
 * @param title 标题
 *
 */
- (UILabel *)nx_setNavigationItmeTitleView:(NSString *)title;

/*
 * 隐藏tableview header和footer的默认线条
 *
 */
- (void)nx_setExtraCellLineHidden:(UITableView *)tableView;

/*
 * 获取当前屏幕显示的controller
 *
 */
+ (UIViewController *)nx_currentViewController;

@end
