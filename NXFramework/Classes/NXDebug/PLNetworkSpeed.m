//
//  PLNetworkSpeed.m
//  NetMonitor
//
//  Created by zll on 2017/12/17.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "PLNetworkSpeed.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@interface PLNetworkSpeed ()
{
    uint32_t _iBytes;       // 下载字节数
    uint32_t _oBytes;       // 上传字节数
    uint32_t _allFlow;      // 所有字节流
    uint32_t _wifiIBytes;   // wifi下载字节数
    uint32_t _wifiOBytes;   // wifi上传字节数
    uint32_t _wifiFlow;     // wifi字节流
    uint32_t _wwanIBytes;   // 蜂窝网下载字节
    uint32_t _wwanOBytes;   // 蜂窝网上传字节
    uint32_t _wwanFlow;     // 蜂窝字节流
}

@property (nonatomic, copy) NSString * downloadPLNetworkSpeed;

@property (nonatomic, copy) NSString * uploadPLNetworkSpeed;

@property (nonatomic, strong) NSTimer * timer;

/**
 检测网络
 */
-(void)checkNetworkflow;

@end

@implementation PLNetworkSpeed

NSString *const kNetworkDownloadSpeedNotification = @"kNetworkDownloadSpeedNotification";

NSString *const kNetworkUploadSpeedNotification = @"kNetworkUploadSpeedNotification";

static PLNetworkSpeed * instance = nil;

+ (instancetype)shareNetworkSpeed{
    if(instance == nil){
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init] ;
        }) ;
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(instance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}

-(instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        _uploadPLNetworkSpeed = @"";
        _downloadPLNetworkSpeed = @"";
        _iBytes = _oBytes = _allFlow = _wifiIBytes = _wifiOBytes = _wifiFlow = _wwanIBytes = _wwanOBytes = _wwanFlow = 0;
    });
    return instance;
}

- (void)startMonitoringNetworkSpeed
{
    if(_timer) [self stopMonitoringNetworkSpeed];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(netSpeedNotification) userInfo:nil repeats:YES];
}

- (void)stopMonitoringNetworkSpeed
{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
}

- (void)netSpeedNotification
{
    [self checkNetworkflow];
}

-(NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 10)
    {
        return [NSString stringWithFormat:@"0KB"];
    }
    else if(bytes >= 10 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.1fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.1fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

-(void)checkNetworkflow
{
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1) return ;
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family) continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) continue;
        
        if (ifa->ifa_data == 0) continue;
        
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        
        // WIFI
        if (!strcmp(ifa->ifa_name, "en0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        
        // WWAN
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    if (_iBytes != 0)
    {
        self.downloadPLNetworkSpeed = [[self bytesToAvaiUnit:iBytes - _iBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkDownloadSpeedNotification object:@{@"received":self.downloadPLNetworkSpeed}];
    }
    
    _iBytes = iBytes;
    
    if (_oBytes != 0)
    {
        self.uploadPLNetworkSpeed = [[self bytesToAvaiUnit:oBytes - _oBytes] stringByAppendingString:@"/s"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkUploadSpeedNotification object:@{@"send":self.uploadPLNetworkSpeed}];
    }
    
    _oBytes = oBytes;
}

@end
