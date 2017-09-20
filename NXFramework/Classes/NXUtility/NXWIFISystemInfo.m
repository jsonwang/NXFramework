//
//  NXWIFISystemInfo.m
//  NXlib
//
//  Created by AK on 15/2/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NXWIFISystemInfo.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>

#include <SystemConfiguration/SystemConfiguration.h>

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NXWIFISystemInfo

+ (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs) == 0)
    {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                {
                    localIP =
                        [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

- (NSDictionary *)getWIFIDic
{
    CFArrayRef myArray = CFBridgingRetain((__bridge id)CNCopySupportedInterfaces());
    if (myArray != nil)
    {
        CFDictionaryRef myDict =
            CFBridgingRetain((__bridge_transfer id)CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0)));

        if (myDict != nil)
        {
            NSDictionary *dic = (NSDictionary *)CFBridgingRelease(myDict);
            return dic;
        }
    }
    return nil;
}

// bssid 路由的 MAC 地址
- (NSString *)getBSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil)
    {
        return nil;
    }
    return dic[@"BSSID"];
}

// SSID是Service Set Identifier的缩写，意思是：服务集标识  wifi 名
- (NSString *)getSSID
{
    NSDictionary *dic = [self getWIFIDic];
    if (dic == nil)
    {
        return nil;
    }
    return dic[@"SSID"];
}

//向 IOS 系统注册 批定WIFI路由名
- (void)registerNetwork:(NSString *)ssid
{
    NSString *values[] = {ssid};
    CFArrayRef arrayRef = CFArrayCreate(kCFAllocatorDefault, (void *)values, (CFIndex)1, &kCFTypeArrayCallBacks);
    if (CNSetSupportedSSIDs(arrayRef))
    {
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        CNMarkPortalOnline((__bridge CFStringRef)(ifs[0]));
        NSLog(@"registerNetwork %@", ifs);
    }
}

@end
