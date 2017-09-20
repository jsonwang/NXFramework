
//@see https://github.com/dustturtle/RealReachability

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
typedef enum : NSInteger {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableVia2G,
    ReachableVia3G,
    ReachableVia4G
} NetworkStatus;

extern NSString *kReachabilityChangedNotification;

@interface NXReachability : NSObject
{
    CTTelephonyNetworkInfo *telephonyNetworkInfo;
}

/* add by ak
 e.g. telephonyNetworkInfo

 //具体的运营商信息@see
 https://developer.apple.com/reference/coretelephony/cttelephonynetworkinfo

 NXReachability * reach = [[NXReachability alloc] init];
 CTTelephonyNetworkInfo *info = reach.telephonyNetworkInfo;
 CTCarrier *carrier = [info subscriberCellularProvider];
 NSString *mcc = [carrier mobileCountryCode];//460-中国
 NSString *mnc = [carrier mobileNetworkCode];//01-联通
 NSString *icc = [carrier isoCountryCode];//cn-中国(使用ISO
 3166-1标准，@seehttps://en.wikipedia.org/wiki/ISO_3166-1)
 */
@property(nonatomic, retain) CTTelephonyNetworkInfo *telephonyNetworkInfo;

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in6 *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications
 * that do not connect to a particular
 * host.
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (NSString *)currentReachabilityString;

- (NetworkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been
 * established. WiFi may require a connection for VPN
 * on Demand.
 */
- (BOOL)connectionRequired;

/**
 *  判断有无网
 *
 *  @return YES 有网
 */
- (BOOL)isCurrentNetworkActive;


/**
 返回国家代号

 @return 国家代号 是大写的如 CN,US
 */
- (NSString *)isoCountryCode;


@end
