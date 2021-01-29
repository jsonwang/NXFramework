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
#import <WebKit/WebKit.h>
@interface NXWebVC ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)UIView * naviView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)NSString * imageURL;
@property(nonatomic,strong)WKWebView * locationWebView;
@property(nonatomic,assign)int gesState;
@property(nonatomic,assign)int locShareType;
@property(nonatomic,assign)BOOL isHiddenNavWhenPushIn;
@end

@implementation NXWebVC
@synthesize isPresent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviView];
    [self initWebView];
    [self initRequest];
}

- (void)initRequest
{
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:self.timeoutInterval];
    [self.locationWebView loadRequest:req];
}
- (void)initWebView
{
    WKWebViewConfiguration * confing = [[WKWebViewConfiguration alloc] init];
    
    WKPreferences * preference = [[WKPreferences alloc] init];
    preference.minimumFontSize = 0;
    preference.javaScriptEnabled = YES;
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    confing.preferences = preference;
    confing.allowsInlineMediaPlayback = YES;
    if (@available(iOS 10.0, *)) {
        confing.mediaTypesRequiringUserActionForPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    
    WKUserContentController * userContentController = [[WKUserContentController alloc] init];
    confing.userContentController =  userContentController;
    
    self.locationWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) configuration:confing];
    
    self.locationWebView.UIDelegate = self;
    self.locationWebView.navigationDelegate = self;
    self.locationWebView.allowsBackForwardNavigationGestures = YES;
    
}

- (void)addObserver
{
    [self.locationWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:@"title"];
    
}

- (void)removeObserve
{
    [self.locationWebView removeObserver:self forKeyPath:@"title"];
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

- (void)backToPrevious
{
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载");
//    [HUDManager showLoading];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //    [self.progressView setProgress:0.0f animated:NO];
    NSLog(@"加载失败");
//    [HUDManager showTextHud:@"loading failure"];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"页面开始加载内容");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // [self getCookie];
    NSLog(@"页面加载完成");
//    [HUDManager hidenHud];
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // [self.progressView setProgress:0.0f animated:NO];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"发送跳转请求：%@",urlStr);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //用户身份信息
    NSURLCredential * newCred = [[NSURLCredential alloc] initWithUser:@"user123" password:@"123" persistence:NSURLCredentialPersistenceNone];
    //为 challenge 的发送方提供 credential
    [challenge.sender useCredential:newCred forAuthenticationChallenge:challenge];
    completionHandler(NSURLSessionAuthChallengeUseCredential,newCred);
}
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}

#pragma mark WKUIDelegate

#pragma  mark WKNavigationDelegate

#pragma mark observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    
    NSString * ctx = (__bridge NSString *)context;
    if ([ctx isEqualToString:@"title"]) {
        
        NSString * title = self.locationWebView.title;
        self.titleLabel.text =   title;
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
#pragma mark Setter / Getter
- (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval <= 0) {
        _timeoutInterval = 15;
    }
    return  _timeoutInterval;
}



#pragma makr -
- (void)dealloc
{
    [self removeObserve];
}
@end
