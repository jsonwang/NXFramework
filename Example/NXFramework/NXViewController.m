//
//  NXViewController.m
//  NXFramework
//
//  Created by wangcheng on 09/20/2017.
//  Copyright (c) 2017 wangcheng. All rights reserved.
//

#import "NXViewController.h"
#import "NXNWListVC.h"

@interface NXViewController ()


@end

@implementation NXViewController

- (void)initDataSource{

    NSArray * array = @[
                        @{
                            NXListTiltleKey:@"网络模块",
                            NXListVCKey:[NXNWListVC class]
                            },
                        ];
    [self.dataSource addObjectsFromArray:array];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
