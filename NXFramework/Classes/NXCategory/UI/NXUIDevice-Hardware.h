
//
//  NXUIDevice-Hardware.h
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

/**
 *  取到硬件相关信息 如果 硬件,内存,电量状态等信息
 *    UI_USER_INTERFACE_IDIOM 是ipad 还是iPhone
 *  @see  Erica Sadun, http://ericasadun.com
 *
 *  支持 MAC 未完
 */

#import <UIKit/UIKit.h>

/**
 *    @brief 设备类型
 */
typedef NS_ENUM(NSUInteger, UIDeviceFamily) {
    /**
     *    iPhone
     */
    UIDeviceFamilyiPhone,
    /**
     *    iPod
     */
    UIDeviceFamilyiPod,
    /**
     *    iPad
     */
    UIDeviceFamilyiPad,
    /**
     *    Unknown
     */
    UIDeviceFamilyUnknown
};

@interface UIDevice (NXHardware)


/**
 * 设备型号 如 iPhone7,2
 */
- (NSString *)nx_platform;
/**
 * 设备号 如 iPhone7,2
 */
- (NSString *)nx_hwmodel;

//设备系统build 版本号
- (NSString *)nx_osVersionBuild;

// CPU 频率
- (NSString *)nx_cpuFrequency;

//总线 频率
- (NSString *)nx_busFrequency;

// CPU大小
- (NSString *)nx_cpuCount;

//内存总大小
- (NSString *)nx_totalMemory;

//已使用内存大小
- (NSString *)nx_userMemory;

/*
 NSFileSystemFreeNodes = 8382164;
 NSFileSystemFreeSize = 34333343744;
 NSFileSystemNodes = 14576375;
 NSFileSystemNumber = 16777220;
 NSFileSystemSize = 59704840192;
 */

// XXX add by ak 这里取到的值都要比 设置->关于里的值大,因为系统有预留空间 @see
// http://stackoverflow.com/questions/11717304/why-does-the-value-from-nsfilesystemfreesize-differ-from-the-free-size-reported
/**
 *  硬盘的总空间
 *
 *  @return 字节数
 */
- (unsigned long long)nx_diskTotalSpace;
/**
 *  硬盘的可有空间
 *
 *  @return 字节数
 */
- (unsigned long long)nx_diskFreeSpace;

/**
 *  判断是不是高清屏幕
 *
 *  @return YES 是高清
 */
- (BOOL)nx_hasRetinaDisplay;

/**
 *  根据ios不同系统版本取出MAC或UUID,并保存到 钥匙串 做为唯一标识
 *
 *  @return 取出来的string idfv || mac 地址
 */
- (NSString *)nx_getIdentifierMacOrIDFV;

/**
 *  取设备IDFV
 *
 *  @return IDFV string
 */
- (NSString *)nx_getIDFV;

/**
 *  获取设备的电量
 *  A方案iOS原生框架获取电量 精确度为 0.05   B方案的精确度为 0.01 需要从外部导入
 * IOKit框架
 *  目前使用的是A方案 , B方案见 m文件的 getCurrentBatteryLevel 方法
 */
- (CGFloat)nx_getBatteryQuantity;

/**
 *  取当前应用可用的内存大小
 free是空闲内存;active是已使用，但可被分页的(在iOS中，只有在磁盘上静态存在的才能被分页，
 例如文件的内存映射，而动态分配的内存是不能被分页的);inactive是不活跃的，实际上内存不足时，
 你的应用就可以抢占这部分内存，因此也可看作空闲内存;wire就是已使用，且不可被分页的
 *
 *  @return byte
 */
+ (unsigned long long)nx_appFreeMemory;
/**
 *  当前应用不活跃内存大小
 *
 *  @return byte
 */
+ (unsigned long long)nx_appInactiveMemory;

/**
 *    @brief 设备类型
 *
 *    @return 设备类型
 */
- (UIDeviceFamily)nx_deviceFamily;

@end

