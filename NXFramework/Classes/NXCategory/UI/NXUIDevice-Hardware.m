
//
//  NXUIDevice-Hardware.m
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NXUIDevice-Hardware.h"
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <sys/sysctl.h>

#import <Security/Security.h>
#include <mach/mach.h>

#import "NXKeychainTools.h"
//以下两个是获取电量B方案需要导入的头文件
//@see
// https://opensource.apple.com/source/IOKitUser/IOKitUser-647.24.2/ps.subproj/IOPowerSourcesPrivate.h
//#import "IOPSKeys.h"
//#import "IOPowerSources.h"

@implementation UIDevice (NXHardware)

#pragma mark sysctlbyname utils
- (NSString *)nx_getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);

    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *)nx_platform { return [self nx_getSysInfoByName:"hw.machine"]; }
// Thanks, Tom Harrington (Atomicbird)
- (NSString *)nx_hwmodel { return [self nx_getSysInfoByName:"hw.model"]; }
#pragma mark sysctl utils
- (NSUInteger)nx_getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger)results;
}

- (NSString *)nx_osVersionBuild
{
    int mib[2] = {CTL_KERN, KERN_OSVERSION};
    size_t size = 0;

    // Get the size for the buffer
    sysctl(mib, 2, NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctl(mib, 2, answer, &size, NULL, 0);

    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    return results;
}

- (NSUInteger)nx_cpuFrequency { return [self nx_getSysInfo:HW_CPU_FREQ]; }
- (NSUInteger)nx_busFrequency { return [self nx_getSysInfo:HW_BUS_FREQ]; }
- (NSUInteger)nx_cpuCount { return [self nx_getSysInfo:HW_NCPU]; }
- (NSUInteger)nx_totalMemory { return [self nx_getSysInfo:HW_PHYSMEM]; }
- (NSUInteger)nx_userMemory { return [self nx_getSysInfo:HW_USERMEM]; }
- (NSUInteger)nx_maxSocketBufferSize { return [self nx_getSysInfo:KIPC_MAXSOCKBUF]; }
#pragma mark file system

- (unsigned long long)nx_diskTotalSpace
{
    NSDictionary *fattributes =
        [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemSize] unsignedLongLongValue];
}

- (unsigned long long)nx_diskFreeSpace
{
    NSDictionary *fattributes =
        [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}

- (BOOL)nx_hasRetinaDisplay { return ([UIScreen mainScreen].scale == 2.0f); }
#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *)nx_macaddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL)
    {
        printf("Error: Memory allocation error\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2\n");
        free(buf);  // Thanks, Remy "Psy" Demerest
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2),
                                                     *(ptr + 3), *(ptr + 4), *(ptr + 5)];

    free(buf);
    return outstring;
}

- (NSString *)nx_getIdentifierMacOrIDFV
{
    NSString *udid = [NXKeychainTools getStringFromKeychainForKey:[NXSystemInfo bundleID] error:nil];

    if (!udid)
    {
        CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
        // 7.0+ mac=20:00:00:00:00
        if (version >= 7.0)
        {
            // e.g. 488D848F-147F-41B2-BA5D-B9F8339FD287
            udid = [self nx_getIDFV];
        }
        else if (version >= 2.0)
        {
            // e.g. 88:1F:A1:DD:29:B2
            udid = [self nx_macaddress];
        }

        NSError *error;

        [NXKeychainTools saveStringToKeychainWithKeyString:[NXSystemInfo bundleID]
                                            saveDataString:udid
                                            updateExisting:YES
                                                     error:&error];
        if (error)
        {
            NSLog(@"保存 udid 到钥匙串错误 %@", error);
        }
    }

    return udid;
}

- (NSString *)nx_getIDFV { return [[UIDevice currentDevice].identifierForVendor UUIDString]; }
- (CGFloat)nx_getBatteryQuantity
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel] * 100;
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    return batteryLevel;
}

/**
 *  获取电量的B方案 需要从外部导入 IOKit框架
 *
 */

/*
 - (double)nx_getCurrentBatteryLevel
 {
 // Returns a blob of Power Source information in an opaque CFTypeRef.
 CFTypeRef blob = IOPSCopyPowerSourcesInfo();

 // Returns a CFArray of Power Source handles, each of type CFTypeRef.
 CFArrayRef sources = IOPSCopyPowerSourcesList(blob);

 CFDictionaryRef pSource = NULL;
 const void *psValue;

 // Returns the number of values currently in an array.
 int numOfSources = CFArrayGetCount(sources);

 // Error in CFArrayGetCount
 if (numOfSources == 0)
 {
 NSLog(@"Error in CFArrayGetCount");
 return -1.0f;
 }

 // Calculating the remaining energy
 for (int i = 0; i < numOfSources; i++)
 {
 // Returns a CFDictionary with readable information about the specific power
 source.
 pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources,
 i));
 if (!pSource)
 {
 NSLog(@"Error in IOPSGetPowerSourceDescription");
 return -1.0f;
 }
 psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));

 int curCapacity = 0;
 int maxCapacity = 0;
 double percent;

 psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
 CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);

 psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
 CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);

 percent = ((double)curCapacity / (double)maxCapacity * 100.0f);

 return percent;
 }
 }
 */

+ (NSUInteger)getAvailableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) return NSNotFound;
    return (vm_page_size * vmStats.free_count);  // / 1024.0) / 1024.0;
}

BOOL memoryInfo(vm_statistics_data_t *vmStats)
{
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);

    return kernReturn == KERN_SUCCESS;
}

+ (unsigned long long)nx_appFreeMemory
{
    vm_statistics_data_t vmStats;

    unsigned long long free_count = 0;
    if (memoryInfo(&vmStats))
    {
        free_count = vmStats.free_count * vm_page_size;
    }

    return free_count;
}
+ (unsigned long long)nx_appInactiveMemory
{
    vm_statistics_data_t vmStats;

    unsigned long long inactive_count = 0;
    if (memoryInfo(&vmStats))
    {
        inactive_count = vmStats.inactive_count * vm_page_size;
    }

    return inactive_count;
}

- (UIDeviceFamily)nx_deviceFamily
{
    NSString *modelIdentifier = [self nx_platform];
    if ([modelIdentifier hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([modelIdentifier hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([modelIdentifier hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    return UIDeviceFamilyUnknown;
}

@end
