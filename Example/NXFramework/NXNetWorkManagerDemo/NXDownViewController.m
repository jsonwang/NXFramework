//
//  NXDownViewController.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/21.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXDownViewController.h"

@interface NXDownViewController ()

@property (strong, nonatomic) UIProgressView *progressUI;
@property(nonatomic,strong) UIButton * startBtn;
@property(nonatomic,strong) UIButton * pauseBtn;
@property(nonatomic,strong) UIButton * cancelBtn;
@property(nonatomic,strong) UIButton * continueBtn;

@property(nonatomic,strong)NXNWRequest * request;
@end

@implementation NXDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.progressUI];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.pauseBtn];
    [self.view addSubview:self.continueBtn];
    [self.view addSubview:self.cancelBtn];
}

- (void)startDownLoad:(id)sender {
    
    NXNWRequest * request = [[NXNWRequest alloc] initWithUrl:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    request.params.addDouble(@"age",12);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    request.fileUrl = path;
    request.requstType = NXNWRequestTypeDownload;
    request.isBreakpoint = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [request startWithProgress:^(NSProgress * progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressUI.progress = progress.fractionCompleted;
            
        });
        
        
        NSLog(@"总大小:%lld 已经下载:%lld 进度:%f",progress.totalUnitCount, progress.completedUnitCount, progress.fractionCompleted);
        
    } success:^(id responseObject, NXNWRequest *rq) {
        
        NSLog(@"下载成功");
    } failure:^(NSError *error, NXNWRequest *rq) {
        
        NSLog(@"error = %@",error);
    }];
    self.request = request;
}

- (void)pauseDownLoad:(id)sender {
    
    [self.request pauseRequest];
}
- (void)cancelDownLoad:(id)sender {
    [self.request cancelRequset];
}
- (void)continueDownLoad:(id)sender {
    
    [self.request resumeRequst];
}

#pragma mark UI View Getter

- (UIProgressView *)progressUI{

    if (_progressUI == nil)
    {
        _progressUI = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressUI.frame = CGRectMake(5, 100, CGRectGetWidth(self.view.frame) - 10, 20);
        _progressUI.progress  = 0.0f;
    }
    return _progressUI;
}
- (UIButton *)startBtn{

    if (_startBtn == nil)
    {
        _startBtn = [self getBtnWithFrame:[self getRectWithIndex:0] title:@"开始"];
        [_startBtn addTarget:self action:@selector(startDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
-(UIButton *)pauseBtn{

    if (_pauseBtn == nil)
    {
        _pauseBtn = [self getBtnWithFrame:[self getRectWithIndex:1] title:@"暂停"];
        [_pauseBtn addTarget:self action:@selector(pauseDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseBtn;
}
- (UIButton *)continueBtn{

    if (_continueBtn == nil) {
        
        _continueBtn = [self getBtnWithFrame:[self getRectWithIndex:2] title:@"暂停"];
        [_continueBtn addTarget:self action:@selector(continueDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueBtn;
}

- (UIButton *)cancelBtn{

    if (_cancelBtn == nil)
    {
        _cancelBtn = [self getBtnWithFrame:[self getRectWithIndex:3] title:@"取消"];
        [_cancelBtn addTarget:self action:@selector(cancelDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (CGRect)getRectWithIndex:(NSInteger)index
{
    double h = 40;
    double w = 60;
    double margin_x = 20.0f;
    double x = (CGRectGetWidth(self.view.frame) - 4 * (w + margin_x))/2.0f + index * (margin_x+ w);
    return CGRectMake(x, 140.0f, w, h);
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
