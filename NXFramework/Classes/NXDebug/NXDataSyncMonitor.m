//
//  PLDataSyncMonitor.m
//  Philm
//
//  Created by zll on 2017/12/18.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXDataSyncMonitor.h"
#import "NXNetworkSpeed.h"

@interface NXDataSyncMonitor ()
{
    NXNetworkSpeed *_networkSpeed;          // 网速单例
    UILabel *_uploadSpeedLbl;               // 上传速度标签
    UILabel *_downloadSpeedLbl;             // 下载速度标签
    UILabel *_eventLbl;                     // 事件标签
    CAGradientLayer *_eventGradientLayer;   // 渐变层
    BOOL isFatalError;                      // 发生严重错误
}
@end

@implementation NXDataSyncMonitor

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        // 开启网络监听
        _networkSpeed = [NXNetworkSpeed shareNetworkSpeed];
        [_networkSpeed startMonitoringNetworkSpeed];
        
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize size = self.frame.size;
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.85f].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [self.layer addSublayer:gradientLayer];
        
        UILabel *uploadIconLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width * 0.08, 20)];
        uploadIconLbl.textColor = [UIColor redColor];
        uploadIconLbl.text = @"⬆︎";
        [self addSubview:uploadIconLbl];
        
        _uploadSpeedLbl = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.08, 0, size.width * 0.25, 20)];
        _uploadSpeedLbl.font = [UIFont boldSystemFontOfSize:12.f];
        _uploadSpeedLbl.textColor = [UIColor whiteColor];
        [self addSubview:_uploadSpeedLbl];
        
        UILabel *downloadIconLbl = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.33, 0, size.width * 0.08, 20)];
        downloadIconLbl.textColor = [UIColor greenColor];
        downloadIconLbl.text = @"⬇︎";
        [self addSubview:downloadIconLbl];
        
        _downloadSpeedLbl = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.41, 0, size.width * 0.25, 20)];
        _downloadSpeedLbl.font = [UIFont boldSystemFontOfSize:12.f];
        _downloadSpeedLbl.textColor = [UIColor whiteColor];
        [self addSubview:_downloadSpeedLbl];
        
        _eventLbl = [[UILabel alloc] initWithFrame:CGRectMake(size.width * 0.66, 0, size.width * 0.34, 20)];
        _eventLbl.font = [UIFont systemFontOfSize:12.f];
        self.event = @"";
        [self addSubview:_eventLbl];
        
        _eventGradientLayer = [CAGradientLayer layer];
        _eventGradientLayer.frame = _eventLbl.frame;
        _eventGradientLayer.startPoint = CGPointMake(0, 0);
        _eventGradientLayer.endPoint   = CGPointMake(1, 0);
        [self.layer addSublayer:_eventGradientLayer];
        _eventGradientLayer.mask = _eventLbl.layer;
        _eventLbl.frame = _eventGradientLayer.bounds;
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

- (void)update
{
    _uploadSpeedLbl.text = [NSString stringWithFormat:@"%@", _networkSpeed.uploadPLNetworkSpeed];
    _downloadSpeedLbl.text = [NSString stringWithFormat:@"%@", _networkSpeed.downloadPLNetworkSpeed];
}

- (void)close
{
    // 停止网速监控
    [_networkSpeed stopMonitoringNetworkSpeed];
    // 移除视图
    [self removeFromSuperview];
}

- (void)setEvent:(NSString *)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _event = [event stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (isFatalError)
        {
            _eventLbl.textColor = [UIColor greenColor];
            _eventLbl.text = [NSString stringWithFormat:@"!!!%@!!!", _event];
            _eventGradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                                           (id)[UIColor redColor].CGColor];
        }
        else
        {
            if (_event.length == 0)
            {
                _eventLbl.textColor = [UIColor greenColor];
                _eventLbl.text = @"暂无更新";
                _eventGradientLayer.colors = @[(id)[UIColor greenColor].CGColor,
                                               (id)[UIColor greenColor].CGColor];
            }
            else
            {
                _eventLbl.textColor = [UIColor whiteColor];
                _eventLbl.text = [NSString stringWithFormat:@"%@", _event];
                switch (arc4random()%4)
                {
                    case 0:
                    {
                        _eventGradientLayer.colors = @[(id)[UIColor redColor].CGColor,
                                                       (id)[UIColor greenColor].CGColor,
                                                       (id)[UIColor yellowColor].CGColor,
                                                       (id)[UIColor blueColor].CGColor];
                    }
                        break;
                    case 1:
                    {
                        _eventGradientLayer.colors = @[(id)[UIColor blueColor].CGColor,
                                                       (id)[UIColor redColor].CGColor,
                                                       (id)[UIColor greenColor].CGColor,
                                                       (id)[UIColor yellowColor].CGColor];
                    }
                        break;
                    case 2:
                    {
                        _eventGradientLayer.colors = @[(id)[UIColor yellowColor].CGColor,
                                                       (id)[UIColor blueColor].CGColor,
                                                       (id)[UIColor redColor].CGColor,
                                                       (id)[UIColor greenColor].CGColor];
                    }
                        break;
                    case 3:
                    {
                        _eventGradientLayer.colors = @[(id)[UIColor greenColor].CGColor,
                                                       (id)[UIColor yellowColor].CGColor,
                                                       (id)[UIColor blueColor].CGColor,
                                                       (id)[UIColor redColor].CGColor];
                    }
                        break;
                }
            }
        }
    });
}

- (void)setEvent:(NSString *)event level:(NXDataSyncEventLevel)level
{
    if (!isFatalError)
    {
        if (level == NXDataSyncEventLevelFatalError)
        {
            isFatalError = YES;
        }
        self.event = event;
    }
}

@end
