//
//  NXBatchViewController.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/21.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXBatchViewController.h"
#import "PLRequest.h"
@interface NXBatchViewController ()

@property(nonatomic,strong) UIButton * testBatchRequestBtn;
@property(nonatomic,strong) UIButton * testBatchRequestWithFailureBtn;
@property(nonatomic,strong) UIButton * testCancelBatchRequestBtn;
@end

@implementation NXBatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.testBatchRequestBtn];
    [self.view addSubview:self.testBatchRequestWithFailureBtn];
    [self.view addSubview:self.testCancelBatchRequestBtn];
}

- (void)testBatchRequest:(id)sender
{
    NXBatchRequest *batchRequest = [[NXBatchRequest alloc] init];
    [batchRequest addRequests:^(NSMutableArray *requestPool) {
       
        PLRequest * rq1 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/get"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq1.params.addString(@"method",@"get");
        rq1.ingoreDefaultHttpParams = YES;
        rq1.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq2 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/put"];
        rq2.httpMethod = NXHTTPMethodTypeOfPUT;
        rq2.ingoreDefaultHttpParams = YES;
        rq2.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq3 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/post"];
        rq3.httpMethod = NXHTTPMethodTypeOfPOST;
        rq3.params.addString(@"method",@"post");
        rq3.ingoreDefaultHttpParams = YES;
        rq3.ingoreDefaultHttpHeaders = YES;
        
        [requestPool addObject:rq1];
        [requestPool addObject:rq2];
        [requestPool addObject:rq3];
        
    }];
    
    [batchRequest startWithSuccess:^(NSArray *resposeObjs) {
       
        NSLog(@"批量 请求成功");
        
    } failure:^(NSArray *errors) {
        
        NSLog(@"批量 请求失败");
    }];
    
}

- (void)testBatchRequestWithFailure:(id)sender
{
    
    NXBatchRequest *batchRequest = [[NXBatchRequest alloc] init];
    [batchRequest addRequests:^(NSMutableArray *requestPool) {
        
        PLRequest * rq1 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/get"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq1.params.addString(@"method",@"get");
        rq1.ingoreDefaultHttpParams = YES;
        rq1.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq2 = [[PLRequest alloc] initWithUrl:@"https://kangzubin.cn/test/timeout.php"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq2.timeOutInterval = 5.0f;
        rq2.ingoreDefaultHttpParams = YES;
        rq2.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq3 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/post"];
        rq3.httpMethod = NXHTTPMethodTypeOfPOST;
        rq3.params.addString(@"method",@"post");
        rq3.ingoreDefaultHttpParams = YES;
        rq3.ingoreDefaultHttpHeaders = YES;
        
        [requestPool addObject:rq1];
        [requestPool addObject:rq2];
        [requestPool addObject:rq3];
        
    }];
    
    [batchRequest startWithSuccess:^(NSArray *resposeObjs) {
        
        NSLog(@"批量 请求成功");
        
    } failure:^(NSArray *errors) {
        
        NSLog(@"批量 请求失败");
    }];
    
}
- (void)testCancelBatchRequest:(id)sender
{
    
    NXBatchRequest *batchRequest = [[NXBatchRequest alloc] init];
    [batchRequest addRequests:^(NSMutableArray *requestPool) {
        
        PLRequest * rq1 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/get"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq1.params.addString(@"method",@"get");
        rq1.ingoreDefaultHttpParams = YES;
        rq1.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq2 = [[PLRequest alloc] initWithUrl:@"https://kangzubin.cn/test/timeout.php"];
        rq1.httpMethod = NXHTTPMethodTypeOfGET;
        rq2.timeOutInterval = 5.0f;
        rq2.ingoreDefaultHttpParams = YES;
        rq2.ingoreDefaultHttpHeaders = YES;
        
        PLRequest * rq3 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/post"];
        rq3.httpMethod = NXHTTPMethodTypeOfPOST;
        rq3.params.addString(@"method",@"post");
        rq3.ingoreDefaultHttpParams = YES;
        rq3.ingoreDefaultHttpHeaders = YES;
        
        [requestPool addObject:rq1];
        [requestPool addObject:rq2];
        [requestPool addObject:rq3];
        
    }];
    
    [batchRequest startWithSuccess:^(NSArray *resposeObjs) {
        
        NSLog(@"批量 请求成功");
        
    } failure:^(NSArray *errors) {
        
        NSLog(@"批量 请求失败");
    }];
    
    sleep(2.0);
    [batchRequest cancelRequst];
    
}

#pragma mark - btn Getter
- (UIButton *)testCancelBatchRequestBtn
{
    if (_testCancelBatchRequestBtn == nil)
    {
        _testCancelBatchRequestBtn = [self getBtnWithFrame:[self getRectWithIndex:0] title:@"testCancelBatch"];
        [_testCancelBatchRequestBtn addTarget:self action:@selector(testCancelBatchRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testCancelBatchRequestBtn;
}
- (UIButton *)testBatchRequestBtn{

    if (_testBatchRequestBtn == nil)
    {
        _testBatchRequestBtn = [self getBtnWithFrame:[self getRectWithIndex:1] title:@"testBatchRequest"];
        [_testBatchRequestBtn addTarget:self action:@selector(testBatchRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBatchRequestBtn;
}

-(UIButton *)testBatchRequestWithFailureBtn{

    if (_testBatchRequestWithFailureBtn == nil)
    {
        _testBatchRequestWithFailureBtn = [self getBtnWithFrame:[self getRectWithIndex:2] title:@"testBatchRequestFailure"];
        [_testBatchRequestWithFailureBtn addTarget:self action:@selector(testBatchRequestWithFailure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testBatchRequestWithFailureBtn;
}

- (CGRect)getRectWithIndex:(NSInteger)index
{
    double margin_y = 20.0f;
    double h = 40;
    double x = 20;
    double w = CGRectGetWidth(self.view.frame) - x * 2;
    double y = 64 + (index + 1) * margin_y + index * h;
    return CGRectMake(x, y, w, h);
}
- (UIButton *)getBtnWithFrame:(CGRect)rect title:(NSString *)title
{
    UIButton * btn = [[UIButton alloc] initWithFrame:rect];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitle:title forState:UIControlStateHighlighted];
    return btn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
