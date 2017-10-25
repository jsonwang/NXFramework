
//
//  NXSandboxBoardVC.m
//  Philm
//
//  Created by AK on 2017/2/16.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXSandboxBoardVC.h"

#import <QuartzCore/QuartzCore.h>
#import "NXDMItemModel.h"
#import "NXConfig.h"

#import "UIView+NXCategory.h"
#import "SDAutoLayout.h"
#import "NSString+NXCategory.h"

@implementation NXSBCloseButton

+ (UIImage *)closeButtonImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context)
    {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];
    
    // Gradient Declarations
    NSArray *gradientColors = @[ (id)topGradient.CGColor, (id)bottomGradient.CGColor ];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    // Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;
    
    // Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);
    
    // Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation NXSBTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect contentFrame = frame;
        contentFrame.origin = CGPointZero;
        contentFrame = CGRectInset(contentFrame, 10.0f, 10.0f);
        
        _content = [[UITextView alloc] initWithFrame:contentFrame];
        _content.font = [UIFont systemFontOfSize:12.0f];
        _content.textColor = [UIColor blackColor];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.editable = NO;
        _content.dataDetectorTypes = UIDataDetectorTypeLink;
        _content.scrollEnabled = YES;
        _content.backgroundColor = [UIColor whiteColor];
        _content.layer.borderColor = [UIColor grayColor].CGColor;
        _content.layer.borderWidth = 2.0f;
        [self addSubview:_content];
        
        CGRect closeFrame;
        closeFrame.size.width = 40.0f;
        closeFrame.size.height = 40.0f;
        closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
        closeFrame.origin.y = 0.f;
        
        _close = [[UIButton alloc] initWithFrame:closeFrame];
        [_close setImage:[NXSBCloseButton closeButtonImage:closeFrame.size] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}

- (void)setFilePath:(NSString *)path
{
    if ([path hasSuffix:@".plist"] || [path hasSuffix:@".strings"])
    {
        _content.text = [[NSDictionary dictionaryWithContentsOfFile:path] description];
    }
    else
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        _content.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}

- (void)setContentText:(NSString *)text { _content.text = text; }
- (void)onClose:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];
    
    [UIView commitAnimations];
}

- (void)didDisappearingAnimationDone { [self removeFromSuperview]; }
@end

#pragma mark -

@implementation NXSBImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect bounds = frame;
        bounds.origin = CGPointZero;
        bounds = CGRectInset(bounds, 10.0f, 10.0f);
        
        _imageView = [[UIImageView alloc] initWithFrame:bounds];
        _imageView.contentMode = UIViewContentModeCenter;
        
        _zoomView = [[UIView alloc] initWithFrame:bounds];
        [_zoomView addSubview:_imageView];
        _zoomView.backgroundColor = [UIColor whiteColor];
        _zoomView.layer.borderColor = [UIColor grayColor].CGColor;
        _zoomView.layer.borderWidth = 2.0f;
        
        [self addSubview:_zoomView];
        
        CGRect closeFrame;
        closeFrame.size.width = 40.0f;
        closeFrame.size.height = 40.0f;
        closeFrame.origin.x = frame.size.width - closeFrame.size.width + 5.0f;
        closeFrame.origin.y = -55.f;
        _close = [[UIButton alloc] initWithFrame:closeFrame];
        [_close setImage:[NXSBCloseButton closeButtonImage:closeFrame.size] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}

- (void)setFilePath:(NSString *)path
{
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    CGSize size = _imageView.bounds.size;
    size.height -= 30.0f;
    size.width -= 30.0f;
    _imageView.image = img;
}

- (void)onClose:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];
    
    [UIView commitAnimations];
}

- (void)didDisappearingAnimationDone { [self removeFromSuperview]; }
@end

#pragma mark -

@interface NXToolSandboxCell ()
@property(nonatomic, strong) NXDMItemModel *model;
@property(nonatomic, strong) UILabel *titleLabel;
@end

@implementation NXToolSandboxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    CGRect frame = CGRectMake(10, 0, NX_MAIN_SCREEN_WIDTH, CGRectGetHeight(self.bounds));
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"";
    titleLabel.textAlignment = NXTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}
- (void)setItemModel:(NXDMItemModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
}
@end

@interface NXSandboxBoardVC ()
{
}

@end

@implementation NXSandboxBoardVC
@synthesize filePath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"沙盒";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT)
                                              style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 44;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView.tableHeaderView setNeedsLayout];
    [_tableView.tableHeaderView setNeedsDisplay];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"closed"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(closeMe)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _fileArray = [[NSMutableArray alloc] init];
    [_fileArray
     addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.filePath error:NULL]];
}

- (void)closeMe { [self dismissViewControllerAnimated:YES completion:NULL]; }

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [_fileArray count]; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSStringFromClass([self class])
                                stringByAppendingFormat:@"[%ld,%ld]", (long)indexPath.section, (long)indexPath.row];
    
    NXToolSandboxCell *cell = (NXToolSandboxCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NXToolSandboxCell alloc] init];
    }
    
    NSString *file = [_fileArray objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@", filePath, file];
    
    NSString *title = @"";
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
    
    //判断是文件还是文件夹
    if ([[attributes fileType] isEqualToString:NSFileTypeDirectory])
    {
        title = [path lastPathComponent];
    }
    else
    {
        //显示 文件名和大小
        NSNumber *size = [attributes objectForKey:NSFileSize];
        title = [NSString stringWithFormat:@"%@-%@",  [NSString nx_formatByteCount:size.floatValue], file];
    }
    
    NXDMItemModel *model = [[NXDMItemModel alloc] init];
    model.title = title;
    NSLog(@"sandbox path  %@", title);
    [cell setItemModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *file = [_fileArray objectAtIndex:indexPath.row];
    
    BOOL isDirectory = NO;
    NSString *path = [NSString stringWithFormat:@"%@/%@", filePath, file];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
    if (attributes)
    {
        if ([[attributes fileType] isEqualToString:NSFileTypeDirectory])
        {
            isDirectory = YES;
        }
    }
    
    if (isDirectory)
    {
        NXSandboxBoardVC *board = [[NXSandboxBoardVC alloc] init];
        board.filePath = path;
        [self.navigationController pushViewController:board animated:YES];
    }
    else
    {
        //        //显示文件内容框
        //        CGRect detailFrame = CGRectMake(0, 100, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT - 100);
        //
        //        if ([path hasSuffix:@".png"] || [path hasSuffix:@".PNG"] || [path hasSuffix:@".jpg"] ||
        //            [path hasSuffix:@".JPG"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".JPEG"] ||
        //            [path hasSuffix:@".gif"] || [path hasSuffix:@".GIF"])
        //        {
        //            NXSBImageView *detailView = [[NXSBImageView alloc] initWithFrame:detailFrame];
        //            [detailView setFilePath:path];
        //            [self.view addSubview:detailView];
        //            [self.view bringSubviewToFront:detailView];
        //        }
        //        else if ([path hasSuffix:@".strings"] || [path hasSuffix:@".plist"] || [path hasSuffix:@".txt"] ||
        //                 [path hasSuffix:@".log"] || [path hasSuffix:@".csv"] || [path hasSuffix:@".json"])
        //        {
        //            NXSBTextView *detailView = [[NXSBTextView alloc] initWithFrame:detailFrame];
        //            [detailView setFilePath:path];
        //            [self.view addSubview:detailView];
        //            [self.view bringSubviewToFront:detailView];
        //        }
        //        else
        //        {
        //            NXSBTextView *detailView = [[NXSBTextView alloc] initWithFrame:detailFrame];
        //            NSString *str = [NSString stringWithFormat:@"目录不支持 %@ 格式!", [path pathExtension]];
        //            [detailView setContentText:str];
        //            [self.view addSubview:detailView];
        //            [self.view bringSubviewToFront:detailView];
        //        }
        
        NXSandboxPreviewVC * preViewVC  = [[NXSandboxPreviewVC alloc] init];
        preViewVC.path = path;
        [self presentViewController:preViewVC animated:YES completion:nil];
    }
}

@end

@implementation NXSandboxPreviewVC


- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    [self initJSContext];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.nx_width, self.view.nx_height - 40)];
    _webView.delegate =self;
    _webView.scalesPageToFit = YES;
    [_webView setScalesPageToFit:YES];
    
    [self.view addSubview:_webView];
    
    
    if([self.path hasSuffix:@".plist"]){
        
        NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.path]];
        NSString * htmlString = [NSString stringWithFormat:@"<p> %@ </P>",[dic description]];
        [_webView loadHTMLString:htmlString baseURL:nil];
        
    }
    else if([[self.path lowercaseString] hasSuffix:@".md"]||[[self.path lowercaseString] hasSuffix:@".markdown"])
    {
        JSValue *jsFunctionValue = self.jsContext[@"convert"];
        NSString *mdString = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
        JSValue *htmlValue = [jsFunctionValue callWithArguments:@[mdString]];
        //加载css样式
        static NSString *css;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"markdown" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
        });
        NSString *htmlString = [NSString stringWithFormat:@"\
                                <html>\
                                <head>\
                                <title>%@</title>\
                                <style>%@</style>\
                                </head>\
                                <body>\
                                %@\
                                </body>\
                                </html>\
                                ", [self.path lastPathComponent], css, htmlValue.toString];
        [_webView loadHTMLString:htmlString baseURL:nil];
    }
    else {
        
        if(self.path)
        {
            NSURLRequest * request  = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.path]];
            [_webView loadRequest:request];
            
        }
    }
    CGRect closeFrame = CGRectMake((self.view.nx_width - 40)/2.0, _webView.bottom, 40, 40);
    UIImage * closeImg = [NXSBCloseButton closeButtonImage:closeFrame.size];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:closeImg forState:UIControlStateNormal];
    closeBtn.frame = closeFrame;
    [closeBtn addTarget:self action:@selector(closeActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
}

- (void)initJSContext
{
    self.jsContext = [[JSContext alloc] init];
    //错误回调
    [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *exception){
        NSLog(@"%@", exception.toString);
    }];
    
    //markdown -> html  js参考 https://github.com/showdownjs/showdown
    static NSString *js;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"showdown" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    });
    //加载js
    [self.jsContext evaluateScript:js];
    
    //注入function  markdown -> html，使用时，可以通过 convert('xxx'); 调用
    NSString *jsFunction = @"\
    function convert(md) { \
    return (new showdown.Converter()).makeHtml(md);\
    }";
    [self.jsContext evaluateScript:jsFunction];
}

- (void)closeActionHandler:(UIButton *)sender{
    
    [self  dismissViewControllerAnimated:YES completion:nil];
}


#pragma UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"开始加载资源");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"加载失败, error = %@",[error userInfo]);
}
@end

