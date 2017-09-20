
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>

#import <CoreFoundation/CoreFoundation.h>

#import "NXReachability.h"

NSString *kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

#pragma mark - Supporting functions

#define kShouldPrintReachabilityFlags 0

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char *comment)
{
#if kShouldPrintReachabilityFlags

    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',

          (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-', comment);
#endif
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
#pragma unused(target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject *)info isKindOfClass:[NXReachability class]],
              @"info was wrong class in ReachabilityCallback");

        NXReachability *noteObject = (__bridge NXReachability *)info;
        // Post a notification to notify the client that the network reachability
        // changed.
        printf("Post a notification to notify the client that the network reachability changed\n");
      
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:noteObject];
}

@interface NXReachability ()
{
}

@end

#pragma mark - NXReachability implementation

@implementation NXReachability
{
    SCNetworkReachabilityRef _reachabilityRef;
}
@synthesize telephonyNetworkInfo;
- (id)init
{
    if (self = [super init])
    {
        telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }

    return self;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName
{
    NSLog(@"hostName: %@", hostName);
    NXReachability *returnValue = NULL;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;

        }
    }
    return returnValue;
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in6 *)hostAddress
{
    SCNetworkReachabilityRef reachability =
        SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);

    NXReachability *returnValue = NULL;

    if (reachability != NULL)
    {
        returnValue = [[self alloc] init];
        if (returnValue != NULL)
        {
            returnValue->_reachabilityRef = reachability;
        }
    }
    return returnValue;
}

+ (instancetype)reachabilityForInternetConnection
{
    struct sockaddr_in6 zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin6_len = sizeof(zeroAddress);
    zeroAddress.sin6_family = AF_INET6;

    return [self reachabilityWithAddress:&zeroAddress];
}

#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
    NSLog(@"启动网络变化监听.");
    BOOL returnValue = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
    {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
        {
            returnValue = YES;
        }
    }

    return returnValue;
}

- (void)stopNotifier
{
    if (_reachabilityRef != NULL)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    [self stopNotifier];
    if (_reachabilityRef != NULL)
    {
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - Network Flag Handling
- (NetworkStatus)nx_networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    PrintReachabilityFlags(flags, "networkStatusForFlags");
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return NotReachable;
    }

    NetworkStatus returnValue = NotReachable;

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll
         assume (for now) that you're on
         Wi-Fi...
         */
        returnValue = ReachableViaWiFi;
    }

    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling
         application is using the CFSocketStream or
         higher APIs...
         */

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableViaWiFi;
        }
    }

    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the
         CFNetwork APIs. mdf by ak return 3G 2G
         */

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            // kvo key
            // CTRadioAccessTechnologyDidChangeNotification
            /*tips
             Now there’s absolutely no documentation around
             currentRadioAccessTechnology, so it took some trial and
             error to make this work. Once you have the current value, you should
             register for the
             CTRadioAccessTechnologyDidChangeNotification instead of polling the
             property. To actually get iOS to emit
             those notifications, you need to carry an instance of
             CTTelephonyNetworkInfo around. Don’t try to create a
             new instance ofCTTelephonyNetworkInfo inside the notification, or it’ll
             crash.
             */
            NSString *currentRadioAccessTechnology = telephonyNetworkInfo.currentRadioAccessTechnology;

            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    return ReachableVia4G;
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                         [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    return ReachableVia2G;
                }
                else
                {
                    return ReachableVia3G;
                }
            }
        }

        returnValue = ReachableVia3G;
        if ((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
        {
            if ((flags & kSCNetworkReachabilityFlagsTransientConnection) ==
                kSCNetworkReachabilityFlagsTransientConnection)
            {
                returnValue = ReachableVia3G;
                if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) ==
                    kSCNetworkReachabilityFlagsConnectionRequired)
                {
                    returnValue = ReachableVia2G;
                }
            }
        }
    }

    return returnValue;
}

- (BOOL)connectionRequired
{
    NSAssert(_reachabilityRef != NULL, @"connectionRequired called with NULL _reachabilityRef");
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }

    return NO;
}

- (NSString *)currentReachabilityString
{
    NetworkStatus temp = [self currentReachabilityStatus];

    switch (temp)
    {
        case NotReachable:
        {
            return NSLocalizedString(@"没有网", @"");
            break;
        }
        case ReachableViaWiFi:
        {
            return NSLocalizedString(@"wifi网", @"");
            break;
        }
        case ReachableVia4G:
        {
            return NSLocalizedString(@"4G网", @"");
            break;
        }
        case ReachableVia3G:
        {
            return NSLocalizedString(@"3G网", @"");
            break;
        }
        case ReachableVia2G:
        {
            return NSLocalizedString(@"2G网", @"");
            break;
        }
        default:
            break;
    }

    return NSLocalizedString(@"No Connection", @"");
}

- (NetworkStatus)currentReachabilityStatus
{
    NSAssert(_reachabilityRef != NULL, @"currentNetworkStatus called with NULL _reachabilityRef");
    NetworkStatus returnValue = NotReachable;
    SCNetworkReachabilityFlags flags;

    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
    {
        returnValue = [self nx_networkStatusForFlags:flags];
        
    }
    NSLog(@"现在的网络状态是 %ld",(long)returnValue);
    return returnValue;
}

- (BOOL)isCurrentNetworkActive { return [self currentReachabilityStatus] && ![self connectionRequired]; }

- (NSString *)isoCountryCode
{
    NSString * upperISOCountryCode = [[[self.telephonyNetworkInfo subscriberCellularProvider] isoCountryCode] uppercaseString];
    NSLog(@"upperISOCountryCode is %@",upperISOCountryCode);
   return upperISOCountryCode;
}

@end
