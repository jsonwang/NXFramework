//
//  yoyo_HTTPUtility.m
//  yoyo
//
//  Created by Dolphin on 7/7/13.
//
//

#import "NXSystemInfo.h"
#import "NXKeychainTools.h"
#import "NXUIDevice-Hardware.h"

#define NXSystemInfoInstance [NXSystemInfo sharedInstance]
// reachability 默认地址
#define NX_REACHABILITY_HOSTNAME_DEFAULT @"www.baidu.com"


/**
 *  设备 token
 */
static NSString *const NXDeviceTokenKey = @"NXDeviceTokenKey";

@interface NXSystemInfo ()
{
    NSString *agent;
    UIDevice *device;
    float deviceVersion;
}
@property(strong, nonatomic) NSDictionary *firstLaunchInfo;  //保存App启动信息
@property(assign, nonatomic) BOOL isFirstLaunchEver;         // App首次安装第一交启动
@property(assign, nonatomic) BOOL isFirstLaunchForVersion;   // App更新安装第一交启动

@end

static NXSystemInfo *single_instance_ = nil;

@implementation NXSystemInfo
@synthesize reachability;

NXSINGLETON(NXSystemInfo);

+ (NSString *)bundleVersion { return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; }
+ (NSString *)version { return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; }
+ (NSString *)bundleID { return [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey]; }
+ (NSString *)bundleDisplayName { return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]; }
+ (NSString *)bundleName { return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]; }
+ (UIInterfaceOrientation)orientation { return [UIApplication sharedApplication].statusBarOrientation; }
+ (BOOL)isPortrait { return UIInterfaceOrientationIsPortrait([NXSystemInfo orientation]); }
+ (BOOL)isLandscape { return UIInterfaceOrientationIsLandscape([NXSystemInfo orientation]); }
+ (CGSize)size { return [[UIScreen mainScreen] bounds].size; }
+ (CGFloat)width { return [NXSystemInfo size].width; }
+ (CGFloat)height { return [NXSystemInfo size].height; }
+ (NSString *)appStoreURL:(NSString *)appID { return [NSString stringWithFormat:@"%@%@", NXAppStoreURL, appID]; }
+ (void)launchAppStore:(NSString *)appID
{
    NSString *downloadURLString = [self.class appStoreURL:appID];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    [[UIApplication sharedApplication] openURL:downloadURL];
}

+ (void)configFirstLaunch
{
    NSDictionary *oldVersionTrail = [NXUserDefaults objectForKey:kNXUserDefaultsVersionTrail];

    if (oldVersionTrail == nil)
    {
        NXSystemInfoInstance.isFirstLaunchEver = YES;

        NXSystemInfoInstance.firstLaunchInfo = @{kNXVersionKey : [NSMutableArray new]};
    }
    else
    {
        NXSystemInfoInstance.isFirstLaunchEver = NO;

        NXSystemInfoInstance.firstLaunchInfo = @{
            kNXVersionKey : [oldVersionTrail[kNXVersionKey] mutableCopy],

        };
    }

    if ([NXSystemInfoInstance.firstLaunchInfo[kNXVersionKey] containsObject:[self version]])
    {
        NXSystemInfoInstance.isFirstLaunchForVersion = NO;
    }
    else
    {
        NXSystemInfoInstance.isFirstLaunchForVersion = YES;

        [NXSystemInfoInstance.firstLaunchInfo[kNXVersionKey] addObject:[self version]];
    }

    [NXUserDefaults setObject:NXSystemInfoInstance.firstLaunchInfo forKey:kNXUserDefaultsVersionTrail];
}

+ (BOOL)isFirstLaunchEver
{
    NSDictionary *oldVersionTrail = [NXUserDefaults objectForKey:kNXUserDefaultsVersionTrail];

    if (![oldVersionTrail nx_isNotEmpty])
    {
        NSLog(@"请调用 configFirstLaunch 方法再使用值");
    }
    return [NXSystemInfo sharedInstance].isFirstLaunchEver;
}
+ (BOOL)isFirstLaunchForVersion
{
    NSDictionary *oldVersionTrail = [NXUserDefaults objectForKey:kNXUserDefaultsVersionTrail];

    if (![oldVersionTrail nx_isNotEmpty])
    {
        NSLog(@"请调用 configFirstLaunch 方法再使用值");
    }
    return [NXSystemInfo sharedInstance].isFirstLaunchForVersion;
}
+ (void)saveDeviceTokenKey:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"原TOKEN %@", token);
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"截取后TOKEN %@", token);
    NXUserDefaultsSave(NXDeviceTokenKey, token);
}

- (id)init
{
    if (self = [super init])
    {
        agent = nil;
        device = [UIDevice currentDevice];
        deviceVersion = [[device systemVersion] floatValue];
    }
    return self;
}

- (void)setReachability:(NXReachability *)reachability_
{
    reachability = reachability_;

    NSLog(@"Reachability obj %p", reachability);
}
- (NXReachability *)reachability
{
    if (!reachability)
    {
        NSLog(@"外层没有设置,使用默认domain初始化");
        reachability = [NXReachability reachabilityWithHostName:NX_REACHABILITY_HOSTNAME_DEFAULT];
    }

    return reachability;
}
- (NSString *)agent
{
    if (agent == nil)
    {
        NSError *error;
        NSString *saveSource = [NXKeychainTools getStringFromKeychainForKey:kYOYOChannelName error:&error];
        if (error)
        {
            NSLog(@"get kYOYOChannelName error %@", error);
        }
        agent = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%lu|%lu|%lu|%lu|%lu|%.0llu|%.0llu|%@|%d|%.0f|%."
                                           @"0f|%@|%@|%d|%@",
                                           saveSource,                                                //渠道号
                                           [@"ios." stringByAppendingString:[NXSystemInfo version]],  //客户端版本号
                                           [device nx_platform],                                      //设备型号
                                           [device nx_hwmodel],                                       //设备号
                                           [device systemVersion],                         //设备系统版本号
                                           [device nx_osVersionBuild],                     //设备系统build 版本号
                                           (unsigned long)[device nx_cpuFrequency],        // CPU 频率
                                           (unsigned long)[device nx_busFrequency],        //总线 频率
                                           (unsigned long)[device nx_cpuCount],            // CPU大小
                                           (unsigned long)[device nx_totalMemory],         //内存总大小
                                           (unsigned long)[device nx_userMemory],          //已使用内存大小
                                           [device nx_diskTotalSpace],                     //硬盘总大小
                                           [device nx_diskFreeSpace],                      //可用硬盘大小
                                           [device nx_getIdentifierMacOrIDFV],             // MAC
                                           [device nx_hasRetinaDisplay],                   //是否高清
                                           [NXSystemInfo width],                           //设备宽
                                           [NXSystemInfo height],                          //设备高
                                           [device name],                                  //设置用户名
                                           [device nx_getIDFV],                            // adfv
                                           (int)[reachability currentReachabilityStatus],  //上网方式
                                           NXUserDefaultsGet(NXDeviceTokenKey)

            // token
        ];

        /**
         *  XXXAK 如果在加什么参数，要加到 string 的后面
         */
    }
    return agent;
}

- (float)deviceVersion { return deviceVersion; }
@end
