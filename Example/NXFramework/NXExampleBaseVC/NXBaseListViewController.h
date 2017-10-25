//
//  NXBaseListViewController.h
//  NXFramework
//
//  Created by yoyo on 2017/10/16.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NXListTiltleKey @"title"
#define NXListVCKey     @"vc"


@interface NXBaseListViewController : UIViewController

@property(nonatomic,strong) NSMutableArray * dataSource;
/**
 子类重写 初始化数据源方法
 */
- (void) initDataSource;
@end
