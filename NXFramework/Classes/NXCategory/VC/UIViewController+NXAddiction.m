//
//  UIViewController+addiction.m
//  YOYO
//
//  Created by 王 成 on 8/1/14.
//  Copyright (c) 2014 yoyo-corp.com. All rights reserved.
//

#import "UIViewController+NXAddiction.h"

@implementation UIViewController (NXAddiction)

- (UILabel *)nx_setNavigationItmeTitleView:(NSString *)title
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];

    [titleLable setFont:[UIFont systemFontOfSize:18]];
    titleLable.textColor = NX_UIColorFromRGB(0xffcc2f);
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NXTextAlignmentCenter;
    titleLable.text = title;

    return titleLable;
}

- (void)nx_setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
+ (UIViewController *)nx_currentViewController
{
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController nx_findBestViewController:viewController];
}

+ (UIViewController *)nx_findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController)
    {
        // Return presented view controller
        return [UIViewController nx_findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController nx_findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController nx_findBestViewController:svc.topViewController];
        else
            return vc;
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController nx_findBestViewController:svc.selectedViewController];
        else
            return vc;
    }
    else
    {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
@end
