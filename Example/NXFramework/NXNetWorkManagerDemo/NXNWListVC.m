//
//  NXNWListVC.m
//  NXFramework
//
//  Created by yoyo on 2017/10/16.
//  Copyright © 2017年 wangcheng. All rights reserved.
//

#import "NXNWListVC.h"
#import "NXDownViewController.h"
#import "NXNormalViewController.h"
#import "NXUploadViewController.h"
#import "NXBatchViewController.h"
#import "NXChainViewController.h"

#define NXListTiltleKey @"title"
#define NXListVCKey     @"vc"

@interface NXNWListVC ()
@end

@implementation NXNWListVC


- (void) initDataSource{
    
    NSArray * array = @[
                        @{
                            NXListTiltleKey:@"下载",
                            NXListVCKey:[NXDownViewController class]
                            },
                        @{
                            NXListTiltleKey:@"普通请求",
                            NXListVCKey:[NXNormalViewController class]
                            },
                        @{
                            NXListTiltleKey:@"上传",
                            NXListVCKey:[NXUploadViewController class]
                            },
                        @{
                            NXListTiltleKey:@"批量请求",
                            NXListVCKey:[NXBatchViewController class]
                            },
                        @{
                            NXListTiltleKey:@"链式",
                            NXListVCKey:[NXChainViewController class]
                            }
                        ];
    [self.dataSource addObjectsFromArray:array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
