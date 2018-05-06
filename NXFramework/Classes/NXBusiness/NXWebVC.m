//
//  NXWebVC.m
//  YOYO
//
//  Created by ZhaoLilong on 14-8-13.
//  Copyright (c) 2014年 yoyo-corp.com. All rights reserved.
//

#import "NXWebVC.h"
#import "NXConfig.h"
#import "NXCreateUITool.h"
#import "NSString+NXCategory.h"
@interface NXWebVC ()<UIWebViewDelegate>
{
    UIView * _naviView;
    UILabel *_titleLabel;
    
    NSTimer *_timer;
    
    NSString *_imgURL;
    
    UIWebView *locationWebView;
    
    int _gesState;
    
    int _locShareType;
    BOOL _isHiddenNavWhenPushIn;
}

@end

@implementation NXWebVC
@synthesize isPresent;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NX_iPad;
    _isHiddenNavWhenPushIn = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = _isHiddenNavWhenPushIn;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航条
    [self createNaviView];
    
    if (self.urlTitle && self.urlTitle.length > 0)
    {
        _titleLabel.text = self.urlTitle;
    }
    self.view.backgroundColor = self.backgroudColor  ?  self.backgroudColor : [UIColor whiteColor];
    
    locationWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviView.frame), NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT - CGRectGetMaxY(_naviView.frame))];
    [locationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    locationWebView.scalesPageToFit = YES;
    locationWebView.delegate = self;
    locationWebView.backgroundColor = [UIColor clearColor];
    // add by ak 内页播放视频
    locationWebView.allowsInlineMediaPlayback = YES;
    [self.view addSubview:locationWebView];
}

-(void)createNaviView
{
    // Do any additional setup after loading the view.
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0,0, NX_MAIN_SCREEN_WIDTH, NX_NAVIGATIONBAR_HEIGHT + NX_STATUSBAR_HEIGHT)];
    if (self.naviColor)
    {
        [_naviView setBackgroundColor:self.naviColor];
    }
    [self.view addSubview:_naviView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,NX_STATUSBAR_HEIGHT , NX_MAIN_SCREEN_WIDTH, NX_NAVIGATIONBAR_HEIGHT)];
    _titleLabel.userInteractionEnabled = YES;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = self.titleFont?self.titleFont:[UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = self.titleColor ?  self.titleColor :  NX_RGBA(3, 3, 3, 1);
    [_naviView addSubview:_titleLabel];
    
    UIButton *backBtn = [NXCreateUITool createButtonWithRect:CGRectMake(0, NX_STATUSBAR_HEIGHT, NX_NAVIGATIONBAR_HEIGHT, NX_NAVIGATIONBAR_HEIGHT) superView:_naviView];
    if (self.backImage)
    {
        [backBtn setImage:self.backImage forState:UIControlStateNormal];
        
    }
    if (self.backSelectImage)
    {
        [backBtn setImage:self.backSelectImage forState:UIControlStateHighlighted];
    }
    
    if (self.backTitle)
    {
        [backBtn setTitle:self.backTitle forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        backBtn.titleLabel.textColor = NX_RGBA(3, 3, 3, 1);
    }
    [backBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - actions
- (void)backToPrevious
{
    BOOL animate = YES;
    if (self.hideWebView)
    {
        self.hideWebView();
        animate = NO;
    }
    
    locationWebView.delegate = nil;
    if (self.isPresent)
    {
        [self dismissViewControllerAnimated:animate completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:animate];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *titl = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (titl && titl.length > 0)
    {
        if ([NSString nx_isBlankString:self.urlTitle])
        {
            _titleLabel.text = titl;
            self.urlTitle = titl;
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {}
- (void)dealloc
{
    //http://stackoverflow.com/questions/1520674/exc-bad-access-in-uiwebview
    //解决webView 在contoller 释放的情况下。调用delegate方法引起的崩溃
    locationWebView.delegate = nil;
    [locationWebView stopLoading];
    locationWebView = nil;
}
@end

