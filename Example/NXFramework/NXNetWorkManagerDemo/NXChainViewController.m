//
//  NXChainViewController.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/21.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXChainViewController.h"
#import "PLRequest.h"
#import "NXNWConfig.h"
@interface NXChainViewController ()

@property(nonatomic,strong) UIButton * testChainRequestBtn;
@property(nonatomic,strong) UIButton * testChainRequestWithFailure1Btn;
@property(nonatomic,strong) UIButton * testChainRequestWithFailure2Btn;
@property(nonatomic,strong) UIButton * testCancelChainRequestBtn;
@end

@implementation NXChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.testChainRequestBtn];
    [self.view addSubview:self.testChainRequestWithFailure1Btn];
    [self.view addSubview:self.testChainRequestWithFailure2Btn];
    [self.view addSubview:self.testCancelChainRequestBtn];
}
- (void)testChainRequest:(id)sender {
    
    NXChainRequest * chinRequest = [[NXChainRequest alloc] init];
    chinRequest.buildBlock = ^(NXNWRequest *rq, NSInteger index, BOOL *stop, id preResponseObj) {
      
        rq.config = [NXNWConfig shareInstanced];
        if(index == 0)
        {
            rq.url = @"https://httpbin.org/get";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.params.addString(@"method",@"get");
        }
        if(index == 1){
        
            rq.url = @"https://httpbin.org/post";
            rq.httpMethod = NXHTTPMethodTypeOfPOST;
            rq.params.addString(@"method",@"post");
        }
        if (index == 2) {
            
            rq.url = @"https://httpbin.org/put";
            rq.httpMethod = NXHTTPMethodTypeOfPUT;
            rq.params.addString(@"method",@"put");
        }
        //这种写法不安全。
        *stop =(index >= 3);
    };
    
    [chinRequest startWithSucces:^(NSArray *resposeObjs) {
       
        NSLog(@"-------- chain requst success -------------");
    } failure:^(NSArray *errors) {
        
        NSLog(@"-------- chain requst failure -------------");
    }];
}

- (void)testChainRequestWithFailure1:(id)sender {
    
    NXChainRequest * chinRequest = [[NXChainRequest alloc] init];
    chinRequest.buildBlock = ^(NXNWRequest *rq, NSInteger index, BOOL *stop, id preResponseObj) {
        
        rq.config = [NXNWConfig shareInstanced];
        if(index == 0)
        {
            rq.url = @"https://httpbin.org/get";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.params.addString(@"method",@"get");
        }
        if(index == 1){
            
            rq.url = @"https://httpbin.org/post";
            rq.httpMethod = NXHTTPMethodTypeOfPOST;
            rq.params.addString(@"method",@"post");
            
        }
            
        *stop = (index >= 2);
    };
    [chinRequest startWithSucces:^(NSArray *resposeObjs) {
        
        NSLog(@"-------- chain requst success -------------");
    } failure:^(NSArray *errors) {
        
        NSLog(@"-------- chain requst failure -------------");
    }];
}

- (void)testChainRequestWithFailure2:(id)sender {
    
    NXChainRequest * chinRequest = [[NXChainRequest alloc] init];
    chinRequest.buildBlock = ^(NXNWRequest *rq, NSInteger index, BOOL *stop, id preResponseObj) {
        
        rq.config = [NXNWConfig shareInstanced];
        if(index == 0)
        {
            //            PLRequest * rq1 = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/get"];
            rq.url = @"https://httpbin.org/get";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.params.addString(@"method",@"get");
        }
        if(index == 1){
            
            rq.url = @"https://kangzubin.cn/test/timeout.php";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
           rq.timeOutInterval = 5.0f;
        }
        
        *stop = (index >= 2);
    };
    [chinRequest startWithSucces:^(NSArray *resposeObjs) {
        
        NSLog(@"-------- chain requst success -------------");
    } failure:^(NSArray *errors) {
        
        NSLog(@"-------- chain requst failure -------------");
    }];
}

- (void)testCancelChainRequest:(id)sender {
    
    NXChainRequest * chinRequest = [[NXChainRequest alloc] init];
    chinRequest.buildBlock = ^(NXNWRequest *rq, NSInteger index, BOOL *stop, id preResponseObj) {
        
        rq.config = [NXNWConfig shareInstanced];
        if(index == 0)
        {
            rq.url = @"https://httpbin.org/get";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.params.addString(@"method",@"get");
        }
        if(index == 1){
            
            rq.url = @"https://kangzubin.cn/test/timeout.php";
            rq.httpMethod = NXHTTPMethodTypeOfGET;
            rq.timeOutInterval = 5.0f;
            
        }
        *stop = (index >= 2);
    };
    [chinRequest startWithSucces:^(NSArray *resposeObjs) {
        
        NSLog(@"-------- chain requst success -------------");
    } failure:^(NSArray *errors) {
        
        NSLog(@"-------- chain requst failure -------------");
    }];
    
    [chinRequest performSelector:@selector(cancelRequest) withObject:nil afterDelay:2.0f];
}

#pragma mark Btn Getter
- (UIButton *) testChainRequestBtn{

    if (_testChainRequestBtn == nil)
    {
        _testChainRequestBtn = [self getBtnWithFrame:[self getRectWithIndex:0] title:@"testChainRequest"];
        [_testChainRequestBtn addTarget:self action:@selector(testChainRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _testChainRequestBtn;
}

- (UIButton *)testChainRequestWithFailure1Btn{

    if (_testChainRequestWithFailure1Btn == nil)
    {
        _testChainRequestWithFailure1Btn = [self getBtnWithFrame:[self getRectWithIndex:1] title:@"testChainRequestWithFailure1"];
        [_testChainRequestWithFailure1Btn addTarget:self action:@selector(testChainRequestWithFailure1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testChainRequestWithFailure1Btn;
}

- (UIButton *)testCancelChainRequestBtn
{
    if (_testCancelChainRequestBtn == nil) {
        
        _testCancelChainRequestBtn = [self getBtnWithFrame:[self getRectWithIndex:2] title:@"testCancelChainRequest"];
        [_testCancelChainRequestBtn addTarget:self action:@selector(testCancelChainRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testCancelChainRequestBtn;
}
- (UIButton *)testChainRequestWithFailure2Btn{

    if (_testChainRequestWithFailure2Btn == nil)
    {
        _testChainRequestWithFailure2Btn = [self getBtnWithFrame:[self getRectWithIndex:3] title:@"testChainRequestWithFailure2"];
        [_testChainRequestWithFailure2Btn addTarget:self action:@selector(testChainRequestWithFailure2:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _testChainRequestWithFailure2Btn;
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
@end
