//
//  NXNormalViewController.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/21.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNormalViewController.h"
#import "PLRequest.h"

#import "NXHttpCmd.h"
#import "NXPostLogics.h"
@interface NXNormalViewController ()<NXAPILogicsDelegate>

@property(nonatomic,strong) UIButton * getBtn;
@property(nonatomic,strong) UIButton * postBtn;
@property(nonatomic,strong) UIButton * headBtn;
@property(nonatomic,strong) UIButton * putBtn;
@property(nonatomic,strong) UIButton * deleteBtn;
@property(nonatomic,strong) UIButton * patchBtn;
@property(nonatomic,strong) UIButton * userAgnet;

@property(nonatomic,strong) UIButton * getwithParams;

@property(nonatomic,strong) UIButton * postWithForm;
@property(nonatomic,strong) UIButton * postWithList;
@property(nonatomic,strong) UIButton * postWithJson;

@property(nonatomic,strong) UIButton * responseWithRAW;
@property(nonatomic,strong) UIButton * responseWithJson;
@property(nonatomic,strong) UIButton * responseWithXML;

@property(nonatomic,strong) UIButton * testFailure;
@property(nonatomic,strong) UIButton * testTimeOut;
@property(nonatomic,strong) UIButton * testCancel;
@property(nonatomic,strong) UIButton * repeatRequest;

@property(nonatomic,assign) float btn_w;   //每个按钮宽度
@property(nonatomic,assign) float btn_h;   //每个按钮的高度
@property(nonatomic,assign) float margin_x; //按钮之间的水平间距
@property(nonatomic,assign) float margin_y; //按钮之间的竖直间距

@property(nonatomic,strong)NXPostLogics * post;
@end

@implementation NXNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.margin_x = 10.0f;
    self.margin_y = 10.0f;
    self.btn_h = 40.0f;
    self.btn_w = 140.0f;
    
    [self.view addSubview:self.getBtn];
    [self.view addSubview:self.postBtn];
    [self.view addSubview:self.headBtn];
    [self.view addSubview:self.putBtn];
    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.patchBtn];
    [self.view addSubview:self.userAgnet];
    [self.view addSubview:self.getwithParams];
    [self.view addSubview:self.postWithForm];
    [self.view addSubview:self.postWithList];
    [self.view addSubview:self.postWithJson];
    [self.view addSubview:self.responseWithRAW];
    [self.view addSubview:self.responseWithJson];
    [self.view addSubview:self.responseWithXML];
    [self.view addSubview:self.testFailure];
    [self.view addSubview:self.testTimeOut];
    [self.view addSubview:self.testCancel];
    [self.view addSubview:self.repeatRequest];
 
    
    
}
#pragma mark -- post
- (void)postWithJson:(id)sender {
    
    
//    PLRequest * request = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
//    request.apiPath = @"post";
//    request.params.addString(@"key",@"value");
//    request.httpMethod = NXHTTPMethodTypeOfPOST;
//    request.requstSerializer = NXHTTPRrequstSerializerTypeJSON;
//    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
//        
//    } failure:^(NSError *error, NXNWRequest *rq) {
//        
//    }];
    
    NXPostLogics * post = [[NXPostLogics alloc] initWithValues:@[@"value"]];
    post.delegate = self;
    post.tag = @"123";
    [post start];
    
}
- (void)postActionHandler:(id)sender {
    
    PLRequest * request = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    request.apiPath = @"post";
    request.params.addString(@"key",@"value");
    request.httpMethod = NXHTTPMethodTypeOfPOST;
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
}
- (void)postWithFormActionHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    requst.apiPath = @"post";
    requst.params.addString(@"key",@"value");
    requst.requstType = NXNWRequestTypeNormal;
    requst.httpMethod = NXHTTPMethodTypeOfPOST;
    requst.requstSerializer = NXHTTPRrequstSerializerTypeRAW;
    requst.resopseSerializer = NXHTTResposeSerializerTypeRAW;
    requst.ingoreDefaultHttpParams = YES;
    requst.ingoreDefaultHttpHeaders = YES;
    [requst startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
}
- (void)postPListActionHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    requst.apiPath = @"post";
    requst.httpMethod = NXHTTPMethodTypeOfPOST;
    requst.ingoreDefaultHttpHeaders = YES;
    requst.ingoreDefaultHttpParams = YES;
    requst.params.addString(@"key1",@"value1").addString(@"key2",@"value2");
    requst.requstSerializer = NXHTTPRrequstSerializerTypePlist;
    [requst startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
}
#pragma mark -- get

- (void)getActionHandler:(id)sender {
    
    PLRequest * request = [[PLRequest alloc] initWithAPIPath:@"check_version.json"];
    request.params.addDouble(@"time",12345).addString(@"哈哈 哈",@"汉 字");
    [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
    
}
- (void)getWithParams:(id)sender {
    
}


#pragma mark head
- (void)headActionHandler:(id)sender {
}
- (void)head:(id)sender {
}
#pragma mark delete
- (void)deleteActionHanlder:(id)sender {
    
    PLRequest * request = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/delete"];
    request.params.addString(@"key",@"value");
    request.httpMethod = NXHTTPMethodTypeOfDELETE;
    request.ingoreDefaultHttpParams = YES;
    request.ingoreDefaultHttpHeaders = YES;
    [request start];
}
#pragma mark put
- (void)putActionHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/put"];
    requst.params.addString(@"value",@"key");
    requst.ingoreDefaultHttpHeaders = YES;
    requst.ingoreDefaultHttpParams = YES;
    requst.httpMethod  = NXHTTPMethodTypeOfPUT;
    [requst start];

    
}
#pragma mark respnse 序列化测试

- (void)responseWtihRawHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    requst.apiPath = @"html";
    requst.httpMethod = NXHTTPMethodTypeOfGET;
    requst.resopseSerializer = NXHTTResposeSerializerTypeRAW;
    requst.ingoreDefaultHttpParams = YES;
    requst.ingoreDefaultHttpHeaders = YES;
    [requst start];
}

- (void)responseWithJson:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    requst.apiPath = @"post";
    requst.httpMethod = NXHTTPMethodTypeOfPOST;
    requst.ingoreDefaultHttpHeaders = YES;
    requst.ingoreDefaultHttpParams = YES;
    requst.params.addString(@"key1",@"value1").addString(@"key1",@"value2");
    requst.resopseSerializer = NXHTTResposeSerializerTypeJSON;
    [requst startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
}
- (void)responseWithXML:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/"];
    requst.apiPath = @"xml";
    requst.httpMethod = NXHTTPMethodTypeOfGET;
    requst.ingoreDefaultHttpHeaders = YES;
    requst.ingoreDefaultHttpParams = YES;
    requst.resopseSerializer = NXHTTResposeSerializerTypeXML;
    [requst startWithSucces:^(id responseObject, NXNWRequest *rq) {
        
    } failure:^(NSError *error, NXNWRequest *rq) {
        
    }];
}
#pragma mark patch
- (void)patchActionHandler:(id)sender {
    
    PLRequest * requset = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/patch"];
    requset.params.addString(@"key",@"value");
    requset.ingoreDefaultHttpHeaders = YES;
    requset.ingoreDefaultHttpParams = YES;
    requset.httpMethod = NXHTTPMethodTypeOfPATCH;
    [requset start];
}
#pragma mark --
- (void)userAgnetHandler:(id)sender {
    PLRequest * requset = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/user-agent"];
    requset.headers.addString(@"User-Agent",@"NXNetworking Custom User Agent");
    requset.httpMethod = NXHTTPMethodTypeOfGET;
    requset.ingoreDefaultHttpParams = YES;
    requset.ingoreDefaultHttpHeaders = YES;
    [requset start];
    
}
#pragma mark 错误测试
- (void)failureActionHandler:(id)sender {
    
    PLRequest * request = [[PLRequest alloc] initWithUrl:@"https://httpbin.org/status/404"];
    request.httpMethod = NXHTTPMethodTypeOfGET;
    request.ingoreDefaultHttpHeaders = YES;
    request.ingoreDefaultHttpParams = YES;
    [request start];
}
#pragma mark timeOut
- (void)timeOutActionHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc]  initWithUrl:@"https://kangzubin.cn/test/timeout.php"];
    requst.httpMethod = NXHTTPMethodTypeOfGET;
    requst.timeOutInterval = 5.0f;
    requst.ingoreDefaultHttpParams = YES;
    requst.ingoreDefaultHttpHeaders = YES;
    [requst start];
}
#pragma mark - 取消测试
- (void)testCancelHandler:(id)sender {
    
    PLRequest * requst = [[PLRequest alloc]  initWithUrl:@"https://kangzubin.cn/test/timeout.php"];
    requst.httpMethod = NXHTTPMethodTypeOfGET;
    requst.timeOutInterval = 10.0f;
    requst.ingoreDefaultHttpParams = YES;
    requst.ingoreDefaultHttpHeaders = YES;
    [requst start];
    
    sleep(2);
    
    [requst cancelRequset];
}

- (void)repeatRequestAction:(id)sender {
    
    for (NSInteger i  = 0; i < 5; i ++) {
    
        PLRequest * request = [[PLRequest alloc] initWithAPIPath:@"check_version.json"];
        request.params.addDouble(@"time",12345).addString(@"哈哈 哈",@"汉 字");
        [request startWithSucces:^(id responseObject, NXNWRequest *rq) {
            
        } failure:^(NSError *error, NXNWRequest *rq) {
            
        }];
    }
}
#pragma mark Btn Getter
- (UIButton *)getBtn
{
    if (_getBtn == nil) {

        _getBtn = [self getBtnWithFrame:[self getRectWithIndex:0] title:@"Get"];
       [ _getBtn addTarget:self action:@selector(getActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getBtn;
}
- (UIButton *)postBtn
{
    if (_postBtn == nil) {
        
        _postBtn = [self getBtnWithFrame:[self getRectWithIndex:1] title:@"Post"];
        [ _postBtn addTarget:self action:@selector(postActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _postBtn;
}
- (UIButton *)headBtn
{
    if (_headBtn == nil) {
        
        _headBtn = [self getBtnWithFrame:[self getRectWithIndex:2] title:@"Post"];
        [ _headBtn addTarget:self action:@selector(postActionHandler:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headBtn;
}
- (UIButton *)putBtn{

    if (_putBtn == nil){
    
        _putBtn = [self getBtnWithFrame:[self getRectWithIndex:3] title:@"Put"];
        [ _putBtn addTarget:self action:@selector(putActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _putBtn;
}
- (UIButton *)deleteBtn{
    
    if (_deleteBtn == nil){
        
        _deleteBtn = [self getBtnWithFrame:[self getRectWithIndex:4] title:@"Delete"];
        [ _deleteBtn addTarget:self action:@selector(deleteActionHanlder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIButton *)patchBtn{
    
    if (_patchBtn == nil){
        
        _patchBtn = [self getBtnWithFrame:[self getRectWithIndex:5] title:@"Patch"];
        [ _patchBtn addTarget:self action:@selector(patchActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _patchBtn;
}
- (UIButton *)userAgnet{
    
    if (_userAgnet == nil){
        
        _userAgnet = [self getBtnWithFrame:[self getRectWithIndex:6] title:@"userAgnet"];
        [ _userAgnet addTarget:self action:@selector(userAgnetHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgnet;
}
- (UIButton *)getwithParams{
    
    if (_getwithParams == nil){
        
        _getwithParams = [self getBtnWithFrame:[self getRectWithIndex:7] title:@"getwithParams"];
        [ _getwithParams addTarget:self action:@selector(getWithParams:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getwithParams;
}
- (UIButton *)postWithForm{
    
    if (_postWithForm == nil){
        
        _postWithForm = [self getBtnWithFrame:[self getRectWithIndex:8] title:@"postWithForm"];
        [ _postWithForm addTarget:self action:@selector(postWithFormActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postWithForm;
}
- (UIButton *)postWithList{
    
    if (_postWithList == nil){
        
        _postWithList = [self getBtnWithFrame:[self getRectWithIndex:9] title:@"postWithPList"];
        [ _postWithList addTarget:self action:@selector(postPListActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postWithList;
}
- (UIButton *)postWithJson{
    
    if (_postWithJson == nil){
        
        _postWithJson = [self getBtnWithFrame:[self getRectWithIndex:10] title:@"postWithJson"];
        [ _postWithJson addTarget:self action:@selector(postWithJson:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postWithJson;
}
- (UIButton *)responseWithRAW{
    
    if (_responseWithRAW == nil){
        
        _responseWithRAW = [self getBtnWithFrame:[self getRectWithIndex:11] title:@"responseWithRAW"];
        [ _responseWithRAW addTarget:self action:@selector(responseWtihRawHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _responseWithRAW;
}
- (UIButton *)responseWithJson{
    
    if (_responseWithJson == nil){
        
        _responseWithJson = [self getBtnWithFrame:[self getRectWithIndex:12] title:@"responseWithJson"];
        [ _responseWithJson addTarget:self action:@selector(responseWithJson:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _responseWithJson;
}
- (UIButton *)responseWithXML{
    
    if (_responseWithXML == nil)
    {
        _responseWithXML = [self getBtnWithFrame:[self getRectWithIndex:13] title:@"responseWithXML"];
        [ _responseWithJson addTarget:self action:@selector(responseWithXML:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _responseWithXML;
}
- (UIButton *)testFailure{
    
    if (_testFailure == nil)
    {
        _testFailure = [self getBtnWithFrame:[self getRectWithIndex:14] title:@"responseWithXML"];
        [_testFailure addTarget:self action:@selector(failureActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testFailure;
}
- (UIButton *)testTimeOut{
    
    if (_testTimeOut == nil)
    {
        _testTimeOut = [self getBtnWithFrame:[self getRectWithIndex:15] title:@"testTimeOut"];
        [_testTimeOut addTarget:self action:@selector(timeOutActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testTimeOut;
}
//@property(nonatomic,strong) UIButton * testCancel;
- (UIButton *)testCancel{
    
    if (_testCancel == nil)
    {
        _testCancel = [self getBtnWithFrame:[self getRectWithIndex:16] title:@"testCancel"];
        [_testCancel addTarget:self action:@selector(testCancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testCancel;
}
- (UIButton *)repeatRequest{
    
    if (_repeatRequest == nil)
    {
        _testCancel = [self getBtnWithFrame:[self getRectWithIndex:17] title:@"repeatRequest"];
        [_repeatRequest addTarget:self action:@selector(repeatRequestAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatRequest;
}

#pragma mark - helper
- (UIButton *)getBtnWithFrame:(CGRect)rect title:(NSString *)title
{
    UIButton * btn = [[UIButton alloc] initWithFrame:rect];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateHighlighted];
    return btn;
}

- (CGRect)getRectWithIndex:(NSInteger)index{

    double x = [self getXWithIndex:index];
    double y = [self getYWithIndex:index];
    return CGRectMake(x, y, self.btn_w, self.btn_h);
}
- (float) getXWithIndex:(NSInteger) index
{
    NSInteger col = index % 2;
    return self.margin_x *(col + 1) + col * self.btn_w + ((CGRectGetWidth(self.view.frame) - 2 * self.margin_x - 2 * self.btn_w))/2.0f;
}
- (float) getYWithIndex:(NSInteger) index
{
    NSInteger row = index /2;
    return 64 + self.margin_y * (row + 1) + row * self.btn_h ;
}

#pragma mark -delegate
- (void)httpRequstFailure:(NXAPILogics *)apiLogics
{
    NSLog(@"failure == %@",apiLogics.tag);
}
- (void)httpRequestSuccess:(NXAPILogics *)apiLogics
{
    NSLog(@"Success == %@",apiLogics.tag);
}
- (void)httpRequsetProgress:(NXAPILogics *)apiLogics
{

     NSLog(@"Progress == %@",apiLogics.tag);
}
@end
