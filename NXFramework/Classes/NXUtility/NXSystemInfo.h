//
//  yoyo_AudioUtility.h
//  yoyo
//
//  Created by yzhang on 2/22/14.
//
//

#import "NXChannelInfo.h"
#import "NXReachability.h"
static NSString *const NXAppStoreURL = @"https://itunes.apple.com/app/id";

static NSString *const kNXUserDefaultsVersionTrail = @"kNXUserDefaultsVersionTrail";
static NSString *const kNXVersionKey = @"kNXVersionKey";

//@see 事件传递
// https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html

//禁止交互
static inline void NXApplicationLock(void)
{
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
}
//启用交互
static inline void NXApplicationUnLock(void)
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}
@interface NXSystemInfo : NSObject
{
}

+ (NXSystemInfo *)sharedInstance;

/**
 *  检测网络状态 注意:如果使用者没有设置值,会使用默认domain初始化
 */
@property(nonatomic, strong) NXReachability *reachability;

#pragma mark - 取info.plist 信息

/**
 *  build号 e.g. 10000
 *
 *  @return build号
 */
+ (NSString *)bundleVersion;
/**
 *  版本号 e.g. 1.0.0
 *
 *  @return  版本号
 */
+ (NSString *)version;
/**
 *  应用标识 e.g. com.youyouxingyuan.re
 *
 *  @return 应用标识
 */
+ (NSString *)bundleID;
/**
 *  应用名称(桌面显示的名称) e.g. 微信
 *
 *  @return 应用名称
 */
+ (NSString *)bundleDisplayName;
/**
 *  包名 e.g. Philm
 *
 *  @return 包名
 */
+ (NSString *)bundleName;

#pragma mark - 设备方向状态
/**
 *  判断当前设备方向状态
 *
 *  @return 当前方向 e.g. UIInterfaceOrientationPortrait
 */
+ (UIInterfaceOrientation)orientation;

/**
 *  判断是否为 竖屏
 *
 *  @return YES 为竖屏
 */
+ (BOOL)isPortrait;
/**
 *  判断是否为 横屏
 *
 *  @return YES 为横屏
 */
+ (BOOL)isLandscape;

/**
 *  屏幕尺寸
 *
 */
+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;

#pragma mark - 商店下载地址操作
/**
 *  根据appID 取下载地址
 *
 *  @param appID e.g. 1004885070
 *
 *  @return 下载地址
 */
+ (NSString *)appStoreURL:(NSString *)appID;
+ (void)launchAppStore:(NSString *)appID;

#pragma mark - APP首次启动设置
/**
 *  设置启动信息.在`didFinishLaunchingWithOptions`中调用 configFirstLaunch
 */
+ (void)configFirstLaunch;
/**
 *  是否为首次安装第一次启动. 注意只调用了configFirstLaunch方法值才有效
 *
 *  @return YES
 */
+ (BOOL)isFirstLaunchEver;
/**
 *  是否为更新版本第一次启动. 注意只调用了configFirstLaunch方法值才有效
 *
 *  @return YES
 */
+ (BOOL)isFirstLaunchForVersion;

/**
 *  保存设备token  保存key is
 * `NXDeviceTokenKey`,如果不调用这个方法取agent值时token为空!
 *
 *  @param deviceToken 设备token
 */
+ (void)saveDeviceTokenKey:(NSData *)deviceToken;

/**
 *  设备系统版本 e.g. 8.100000
 *
 *  @return 版本号
 */
- (float)deviceVersion;

/**
 *  手机端 agent e.g.
 * appstore|1.0.0|iPad2,5|P105AP|8.1|12B410|656911110|656925476|2|527417344|436150272|13662642176|801984512|BE8E4B48-E954-446C-AB9C-1FD98E7A5C67|1|320|480|wang
 * 的 iPad (2)|0A5B93A6-EF3C-4F18-B0
 *
 *  @return agent string
 */
- (NSString *)agent;

@end
