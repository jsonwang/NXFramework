//
//  NXViewController.m
//  NXFramework
//
//  Created by wangcheng on 09/20/2017.
//  Copyright (c) 2017 wangcheng. All rights reserved.
//

#import "NXViewController.h"
#import "NXNWListVC.h"
#import "PLRequest.h"
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
    
    NSTimeInterval t1 = [[NSDate date] timeIntervalSince1970];
    NSString * url = [NSString stringWithFormat:@"http://datatest.philm.cc/sticker/2017/v23/check_data_version_debug.html?time=%f",t1];
    PLRequest * request = [[PLRequest alloc] initWithUrl:url];
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    request.resopseSerializer = NXHTTResposeSerializerTypeRAW;
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
       NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
        
        NSLog(@"------- %f -------",t2 - t1);
        NSLog(@"jjjjjjjjjjjjj");
    } failure:^(NSError *error, NXNWRequest *rq) {
        
        NSLog(@"llllllll");
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
