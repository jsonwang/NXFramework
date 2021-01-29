//
//  NXSandboxBoardVC.h
//  Philm
//
//  Created by AK on 2017/2/16.
//  Copyright © 2017年 yoyo. All rights reserved.
//

/* 功用,显示沙盒里的文件,并支持图片,文字类文件预览.
 *
 *
 *
 *
 */
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface NXSBCloseButton : NSObject

+ (UIImage *)closeButtonImage:(CGSize)size;
@end

@interface NXSBTextView : UIView
{
    UITextView *_content;
    UIButton *_close;
}

- (void)setFilePath:(NSString *)path;
- (void)setContentText:(NSString *)text;

@end

#pragma mark -

@interface NXSBImageView : UIView
{
    UIImageView *_imageView;
    UIView *_zoomView;
    UIButton *_close;
}
- (void)setFilePath:(NSString *)path;

@end

#pragma mark -

@interface NXToolSandboxCell : UITableViewCell
{
}

- (void)setItemModel:(NSObject *)model;
@end

#pragma mark -
@interface NXSandboxBoardVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_filePath;
    NSMutableArray *_fileArray;
    
    UITableView *_tableView;
}
@property(nonatomic, retain) NSString *filePath;
@property(nonatomic, retain) UITableView *tableView;
@end

@interface NXSandboxPreviewVC : UIViewController<WKUIDelegate,WKNavigationDelegate>{
    
    WKWebView * _webView;
}

@property(nonatomic, strong) JSContext *jsContext;

@property(nonatomic,strong) NSString * path;
@end

