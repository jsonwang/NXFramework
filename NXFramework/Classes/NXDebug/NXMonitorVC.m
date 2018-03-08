//
//  NXMonitorVC.m
//  MonitorTool
//
//  Created by AK on 2016/12/17.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXMonitorVC.h"
#import "NXLogManager.h"

@interface NXMonitorVC ()<UITextViewDelegate>
{
    UITextView *logTextView;
}

@end

@implementation NXMonitorVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor yellowColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"closed"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(closeMe)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"AirDrop"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleAirDrop:)];

    //初始化
    logTextView = [[UITextView alloc] initWithFrame:self.view.frame];

    //设置代理 需在interface中声明UITextViewDelegate
    logTextView.delegate = self;
    //字体大小
    logTextView.font = [UIFont systemFontOfSize:16];
    logTextView.editable = NO;
    //是否可以滚动
    logTextView.scrollEnabled = YES;
    logTextView.layoutManager.allowsNonContiguousLayout = NO;
    logTextView.scrollsToTop = YES;
    [self.view addSubview:logTextView];
    
    NSString *txtFileContents =
        [NSString stringWithContentsOfFile:[NXLogManager getLogFilePath] encoding:NSUTF8StringEncoding error:NULL];
    logTextView.text = txtFileContents;
    [logTextView scrollRangeToVisible:NSMakeRange(logTextView.text.length, 1)];

}

- (void)closeMe { [self dismissViewControllerAnimated:YES completion:NULL]; }
- (void)handleAirDrop:(id)sender
{
    NSArray *objectsToShare = @[ [NSURL fileURLWithPath:[NXLogManager getLogFilePath]] ];
    
    UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)])
    {
        // iOS8
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
        activityViewController.popoverPresentationController.sourceView = self.view;
#pragma clang diagnostic pop
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
