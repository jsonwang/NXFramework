//
//  QYMonitorView.m
//  MonitorTool
//
//  Created by liuming on 16/9/29.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXMonitorView.h"
#import "NXLogManager.h"
#import "NXMonitorItem.h"
#import "NXMonitorMoreCell.h"
#import "NXSendMail.h"
#import "NXSandboxBoardVC.h"
#import "NXCatonMonitor.h"
#import "NXAlertView.h"
#import "NXSoundVC.h"

#define NX_DMItemWidth 40.0f
#define NX_DMItemHeight 40.0f

#define NX_DMContentHeight 60.f
// NXMonitorView 最后拖拽结束后的位置
#define NX_MonitorView_LastRect_Key @"NX_MonitorView_LastPanPoint_Key"
//更多面板最后拖拽结束位置
#define NX_MonitorView_CunstomView_LastRect_Key @"NX_MonitorView_CunstomView_LastRect_Key"
// debug window 按钮最后一次拖拽结束位置
#define NX_MonitorView_Btn_lastRect_key @"NX_MonitorView_btn_lastRect_key"
// contentView 最后拖拽结束的位置
#define NX_MonitorView_ContentView_LastRect_key @"NX_MonitorView_ContentView_LastRect_key"

NSString *const rootViewControllerChangeContext = @"changeKeyWindow";

#include "NXMonitorVC.h"
@interface NXMonitorView ()<QYMonitorToolDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSArray *monitors;
@property(nonatomic, assign) CGPoint oldPoint;
@property(nonatomic, strong) UIButton *btn;
@property(nonatomic, strong) NXMonitorTool *monitorTool;
@property(nonatomic, strong) NSMutableDictionary *mapDic;
@property(nonatomic, strong) QYMOnitorCustView *customView;
@property(nonatomic, strong) NSArray<NXDMItemModel *> *customArr;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) NXDataSyncMonitor *dataSyncMonitor; // 数据同步监控
@end
@implementation NXMonitorView

- (instancetype)initWithCustomArr:(NSArray<NXDMItemModel *> *)customArr
{
    if (self = [super init])
    {
        self.customArr = customArr;
        [self initSubView];
        [self startMonitor];

        //保存设备日志到文件
        //[NXLogManager redirectNSlogToDocumentFolder];

        //add by ak 卡顿监控
        __weak typeof(self) ws = self;
        [[NXCatonMonitor sharedInstance] starWithCallback:^(NSString *logs) {
            
            ws.btn.backgroundColor = [ws.monitorTool monitorColor:NXMonitorLevelBad];
            NXAlertView * alertView = [[NXAlertView alloc] initWithTitle:@"发生卡顿" message:logs];
            [alertView show];
        }];
    }

    return self;
}
- (NSArray *)monitors
{
    if (_monitors == nil)
    {
        _monitors = [self.monitorTool getMonitors];
    }
    return _monitors;
}
- (NSMutableDictionary *)mapDic
{
    if (_mapDic == nil)
    {
        _mapDic = [[NSMutableDictionary alloc] init];
    }

    return _mapDic;
}
- (NXMonitorTool *)monitorTool
{
    if (_monitorTool == nil)
    {
        _monitorTool = [[NXMonitorTool alloc] init];
        _monitorTool.delegate = self;
    }
    return _monitorTool;
}
- (double)screenHeight { return [UIScreen mainScreen].bounds.size.height; }
- (double)screenWidhth { return [UIScreen mainScreen].bounds.size.width; }
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSubView];
        [self startMonitor];
    }

    return self;
}

- (double)contentWidth { return self.monitors.count >= 5 ? NX_DMItemWidth * 5 : self.monitors.count * 5; }
- (void)initSubView
{
    self.clipsToBounds = YES;
    NSUInteger count = self.monitors.count;
    self.frame = CGRectMake(0, 100, NX_DMItemWidth + [self contentWidth], NX_DMContentHeight);
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:0 / 255.0f green:0 blue:0 alpha:1];
    
    self.contentView =
        [[UIView alloc] initWithFrame:CGRectMake(NX_DMItemWidth, 0, [self contentWidth], NX_DMContentHeight)];
    self.dataSyncMonitor = [[NXDataSyncMonitor alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 20)];
    [self.contentView addSubview:self.dataSyncMonitor];
    self.contentView.clipsToBounds = YES;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.contentView.bounds.size.width, NX_DMItemHeight)];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor redColor];
    for (NSInteger i = 0; i < count; i++)
    {
        double x = i * NX_DMItemWidth;
        NXDMItemModel *model = [self.monitors objectAtIndex:i];
        NXMonitorItem *item = [[NXMonitorItem alloc] initWithFrame:CGRectMake(x, 0, NX_DMItemWidth, NX_DMItemHeight)];
        [item setDataString:model.data];
        [item setTitleString:model.title];
        item.backgroundColor = [UIColor whiteColor];
        item.tag = model.category;
        if (model.canClicked)
        {
            [item setDataString:@""];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = item.tag;
            [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = item.bounds;
            [item addSubview:button];
        }
        [scrollView addSubview:item];
        [self.mapDic setObject:item forKey:@(model.category)];
    }
    double content_x = self.monitors.count * NX_DMItemWidth;
    scrollView.contentSize = CGSizeMake(content_x, scrollView.contentOffset.y);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"⚒" forState:UIControlStateNormal];
    [button setTitle:@"⚒" forState:UIControlStateHighlighted];
    button.selected = YES;
    button.backgroundColor = [UIColor redColor];
    self.btn = button;
    //添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];

    [self.contentView addSubview:scrollView];
    [self addSubview:self.contentView];
    [self addSubview:button];
    [self resumeLastDragStatue];
    
}

- (void)startMonitor { [self.monitorTool startMonitor]; }
- (void)btnClicked:(UIButton *)sender
{
    //    [self changeCloseBtnTransform];
    if (self.customView)
    {
        [self.customView removeFromSuperview];
        self.customView = nil;
    }
    if (sender.selected)
    {
        //关闭
        if ([self isRightBottom])
        {
            if ([self closeBtnIsRight])
            {
                //
                [self closeFromLeftToRight];
            }
            else
            {
                [self closeFromLeftToRight];
            }
        }
        else
        {
            if ([self closeBtnIsRight])
            {
                [self closeFromRightToLeft];
            }
            else
            {
                [self closeFromLeft];
            }
        }
    }
    else
    {
        //打开
        if ([self isRightBottom])
        {
            [self showFromRight];
        }
        else
        {
            [self showFromLeft];
        }
    }
    sender.selected = !sender.selected;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //等待打开和关闭动画完成后记录操作状态
        [self recordCurrentOpreationStatue];
    });
}
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        self.oldPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    }
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        [self moving:[pan locationInView:[UIApplication sharedApplication].keyWindow]];
    }
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        [self endMove:[pan locationInView:[UIApplication sharedApplication].keyWindow]];
    }
}
- (void)moving:(CGPoint)point
{
    double width = self.frame.size.width;
    double height = self.frame.size.height;
    double cHeight = self.customView.frame.size.height;
    double dx = point.x - self.oldPoint.x;
    double dy = point.y - self.oldPoint.y;
    double tx = self.center.x + dx;
    double ty = self.center.y + dy;
    double cty = self.customView.center.y + dy;
    if (tx <= width / 2.0f)
    {
        tx = width / 2.0f;
    }
    if (([self screenWidhth] - tx) <= width / 2.0f)
    {
        tx = [self screenWidhth] - width / 2.0f;
    }
    if (ty - height / 2.0f <= 0)
    {
        ty = height / 2.0f;
    }
    if (([self screenHeight] - ty) <= height / 2.0f)
    {
        ty = [self screenHeight] - height / 2.0f;
    }
    if (cty <= cHeight / 2.0)
    {
        cty = ty + cHeight / 2.0 + height / 2.0;
    }
    if (cty >= [self screenHeight] - cHeight / 2.0)
    {
        cty = ty - height / 2.0 - cHeight / 2.0;
    }
    if (cty < ty)
    {
        cty = MIN(cty, ty - height / 2.0 - cHeight / 2.0);
    }
    else
    {
        cty = MAX(cty, ty + height / 2.0 + cHeight / 2.0);
    }
    self.customView.center = CGPointMake(tx, cty);
    self.center = CGPointMake(tx, ty);
    self.oldPoint = point;
}
- (void)endMove:(CGPoint)point
{
    //限定区间
    double x = 0;
    if (point.x > [self screenWidhth] / 2.0f)
    {
        //靠右
        x = [self screenWidhth] - self.frame.size.width;
    }
    [UIView animateWithDuration:0.25
        animations:^{
            self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            self.customView.frame = CGRectMake(x, self.customView.frame.origin.y, self.customView.frame.size.width,
                                               self.customView.frame.size.height);
        }
        completion:^(BOOL finished) {

            [self recordCurrentOpreationStatue];
        }];
}
- (BOOL)isRightBottom { return (self.frame.size.width + self.frame.origin.x) >= [self screenWidhth]; }
- (BOOL)closeBtnIsRight { return (self.btn.frame.size.width + self.btn.frame.origin.x) >= self.frame.size.width; }
#pragma 所有动画方法
/**
 从左到右打开
 */
- (void)showFromLeft
{
    //靠左
    double x = NX_DMItemWidth;
    double width = [self contentWidth];
    double sw = width + NX_DMItemWidth;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.contentView.frame = CGRectMake(x, 0, width, NX_DMContentHeight);
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sw, CGRectGetHeight(self.frame));
                         self.btn.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);
                     }
                     completion:^(BOOL finished){

                     }];
}
/**
 从右到左打开
 */
- (void)showFromRight
{
    //靠右 向左打开
    double width = [self contentWidth];
    double sw = width + NX_DMItemWidth;
    double x = [self screenWidhth] - sw;
    self.contentView.frame = CGRectMake(0, 0, width, NX_DMContentHeight);
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.btn.frame = CGRectMake(width, 0, NX_DMItemWidth, NX_DMContentHeight);
                         self.frame = CGRectMake(x, self.frame.origin.y, sw, CGRectGetHeight(self.frame));
                     }
                     completion:^(BOOL finished){
                     }];
}
/**
   从左边开始关闭
 */
- (void)closeFromLeft
{
    //整体靠左 关闭按钮在左边
    double x = NX_DMItemWidth;
    double selfWidth = NX_DMItemWidth;
    [UIView animateWithDuration:0.25
        animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, selfWidth, CGRectGetHeight(self.frame));
            self.btn.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);
        }
        completion:^(BOOL finished) {
            self.contentView.frame = CGRectMake(x, 0, 0, NX_DMContentHeight);
        }];
}

/**
 从右边开始关闭
 */
- (void)closeFromRight
{
    //整体靠右 关闭按钮在左边
    double x = [self screenWidhth] - NX_DMItemWidth;
    double sw = NX_DMItemWidth;
    [UIView animateWithDuration:0.25
        animations:^{
            self.frame = CGRectMake(x, self.frame.origin.y, sw, CGRectGetHeight(self.frame));
            self.btn.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);

        }
        completion:^(BOOL finished) {

            self.contentView.frame = CGRectMake(0, 0, sw, NX_DMContentHeight);
        }];
}
/**
从左至右开始关闭
 */
- (void)closeFromLeftToRight
{
    //整体靠右 关闭按钮靠右边
    double x = [self screenWidhth] - NX_DMItemWidth;
    double sw = NX_DMItemWidth;

    [UIView animateWithDuration:0.25
        animations:^{
            self.btn.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);
            self.frame = CGRectMake(x, self.frame.origin.y, sw, CGRectGetHeight(self.frame));
        }
        completion:^(BOOL finished) {

            self.contentView.frame = CGRectMake(NX_DMItemWidth, 0, 0, NX_DMContentHeight);
        }];
}
/**
 从右到左开始关闭
 */
- (void)closeFromRightToLeft
{
    //整体靠左 关闭按钮在右边
    double x = 0.0f;
    double sw = NX_DMItemWidth;
    [UIView animateWithDuration:0.25
        animations:^{
            self.frame = CGRectMake(x, self.frame.origin.y, sw, CGRectGetHeight(self.frame));

            self.btn.frame = CGRectMake(0, 0, NX_DMItemWidth, NX_DMContentHeight);
        }
        completion:^(BOOL finished) {
            self.contentView.frame = CGRectMake(0, 0, sw, NX_DMContentHeight);
        }];
}

- (void)changeCloseBtnTransform
{
    CGAffineTransform transform =
        !self.btn.selected ? CGAffineTransformIdentity : CGAffineTransformRotate(self.btn.transform, M_PI_4);
    self.btn.transform = transform;
}

#pragma mark QYMonitorToolDelegate
- (void)monitor:(NXMonitorTool *)monitor category:(QYMonitorCategory)category data:(NSString *)data
{
    NXMonitorItem *item = [self.mapDic objectForKey:@(category)];
    [item setDataString:data];
}

- (void)monitor:(NXMonitorTool *)monitor level:(NXMonitorLevel)level category:(QYMonitorCategory)category
{
    self.btn.backgroundColor = [self.monitorTool monitorColor:level];
}

- (void)showToWindow:(UIView *)superView
{
    if (superView == nil)
    {
        superView = [[[UIApplication sharedApplication] delegate] window];
    }
    [superView addSubview:self];
    if ([superView respondsToSelector:@selector(rootViewController)])
    {
        [superView addObserver:self
                    forKeyPath:@"rootViewController"
                       options:NSKeyValueObservingOptionNew
                       context:(__bridge void *_Nullable)(rootViewControllerChangeContext)];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context
{
    if (([keyPath isEqualToString:@"rootViewController"] &&
         [((__bridge NSString *)context) isEqualToString:rootViewControllerChangeContext]))
    {
        [self.superview bringSubviewToFront:self];
    }
}
- (void)removeRootViewControllerChange
{
    if ([self.superview respondsToSelector:@selector(rootViewController)])
    {
        [self.superview removeObserver:self forKeyPath:@"rootViewController"];
    }
}
- (void)nextvc:(UIViewController *)vc
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *hostVC = rootVC;
    while (hostVC.presentedViewController)
    {
        hostVC = hostVC.presentedViewController;
    }
    hostVC = hostVC ?: rootVC;
    [hostVC presentViewController:nav animated:YES completion:NULL];
}

- (void)itemClick:(UIButton *)btn
{
    QYMonitorCategory category = btn.tag;

    switch (category)
    {
        case NXMonitorCategoryOfLogs:
        {
            NXMonitorVC *vc = [[NXMonitorVC alloc] init];
            [self nextvc:vc];
            break;
        }
        case NXMonitorCategoryOfSandbox:
        {
            NXSandboxBoardVC *vc = [[NXSandboxBoardVC alloc] init];
            vc.filePath = NSHomeDirectory();
            [self nextvc:vc];
            break;
        }
        case NXMonitorCategoryOfCustom:
        {
            if (self.customArr.count > 0)
            {
                if (self.customView == nil)
                {
                    double w = self.frame.size.width;
                    double h = self.customArr.count >= 5 ? 200 : self.customArr.count * 50;
                    //计算更多view显示的位置
                    double y = self.frame.origin.y >= h ? self.frame.origin.y - h : CGRectGetMaxY(self.frame);
                    self.customView =
                        [[QYMOnitorCustView alloc] initWithFrame:CGRectMake(self.frame.origin.x, y, w, h)];
                    [self.customView refreshData:self.customArr];
                    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                    [keyWindow addSubview:self.customView];
                    [self.monitorTool archivedViewRect:self.customView.frame
                                                forKey:NX_MonitorView_CunstomView_LastRect_Key];
                }
                else
                {
                    [self.monitorTool archivedViewRect:CGRectZero forKey:NX_MonitorView_CunstomView_LastRect_Key];
                    [self.customView removeFromSuperview];
                    self.customView = nil;
                }
            }
            break;
        }
        default:
            break;
    }
}
- (void)dealloc
{
    [self.monitorTool freeTimer];
    self.monitorTool.delegate = nil;
    [self removeRootViewControllerChange];
    NSLog(@"dealloc");
}

- (void)resumeLastDragStatue
{
    //恢复上次的坐标位置
    CGRect selfRect = [self.monitorTool unArchivedViewRectForKey:NX_MonitorView_LastRect_Key];
    if (!CGRectEqualToRect(CGRectZero, selfRect))
    {
        self.frame = selfRect;
    }
    // 默认关闭状态
    [self btnClicked:self.btn];

    /*恢复上次 打开与关闭的状态
    CGRect selfRect = [self.monitorTool
    unArchivedViewRectForKey:NX_MonitorView_LastRect_Key];
    //
    CGRect custViewRect = [self.monitorTool
    unArchivedViewRectForKey:NX_MonitorView_CunstomView_LastRect_Key];
    CGRect btnRect = [self.monitorTool
    unArchivedViewRectForKey:NX_MonitorView_Btn_lastRect_key];
    CGRect contentRect = [self.monitorTool
    unArchivedViewRectForKey:NX_MonitorView_ContentView_LastRect_key];
    if (!CGRectEqualToRect(CGRectZero, selfRect)) {
        self.frame = selfRect;
    } else {
        //第一次，或者没拖动过 debugWindow 默认关闭状态
        [self btnClicked:self.btn];
        return ;
    }
    if (!CGRectEqualToRect(btnRect, CGRectZero)) {
        self.btn.frame = btnRect;
    }
    if (!CGRectEqualToRect(contentRect, CGRectZero)) {

        self.contentView.frame = contentRect;
    }
    if (!CGRectEqualToRect(custViewRect, CGRectZero) && self.customArr.count >0) {

        if (!self.customView) {

            double w = self.frame.size.width;
            double h = self.customArr.count >= 5 ? 200 : self.customArr.count *
    50;
            //计算更多view显示的位置
            double y = self.frame.origin.y >= h ? self.frame.origin.y - h :
    CGRectGetMaxY(self.frame);
            self.customView = [[QYMOnitorCustView alloc]
    initWithFrame:CGRectMake(self.frame.origin.x, y, w, h)];
            [self.customView refreshData:self.customArr];
            UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:self.customView];
        }
        self.customView.frame = custViewRect;
    }
    */
}

- (void)recordCurrentOpreationStatue
{
    //将当前坐标写入沙盒
    [self.monitorTool archivedViewRect:self.frame forKey:NX_MonitorView_LastRect_Key];
    [self.monitorTool archivedViewRect:self.customView.frame forKey:NX_MonitorView_CunstomView_LastRect_Key];
    [self.monitorTool archivedViewRect:self.btn.frame forKey:NX_MonitorView_Btn_lastRect_key];
    [self.monitorTool archivedViewRect:self.contentView.frame forKey:NX_MonitorView_ContentView_LastRect_key];
}

- (void)dsEvent:(NSString *)event
{
    [self dsEvent:event level:NXDataSyncEventLevelNormal];
}
- (void)dsEvent:(NSString *)event level:(NXDataSyncEventLevel)level
{
    [self.dataSyncMonitor setEvent:event level:level];
}
@end

//更多信息
@interface QYMOnitorCustView ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *txtLabel;
@end

@implementation QYMOnitorCustView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 50;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.moreArr.count; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"moreCellId";
    NXMonitorMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[NXMonitorMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setItemModel:self.moreArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NXDMItemModel * model = self.moreArr[indexPath.row];
    if(model.canClicked){
    
        if(model.category == NXMonitorCategoryOfSoundID){
        
            NXSoundVC * vc = [[NXSoundVC alloc] init];
            [self nextvc:vc];
        }
    }
}
- (void)refreshData:(NSArray<NXDMItemModel *> *)moreArr
{
    if (moreArr)
    {
        self.moreArr = moreArr;
    }

    [self.tableView reloadData];
}

- (void)nextvc:(UIViewController *)vc
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *hostVC = rootVC;
    while (hostVC.presentedViewController)
    {
        hostVC = hostVC.presentedViewController;
    }
    hostVC = hostVC ?: rootVC;
    [hostVC presentViewController:nav animated:YES completion:NULL];
}

@end

