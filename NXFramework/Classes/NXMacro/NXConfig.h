//
//  NXConfig.h
//  IntelligentHome
//
//  Created by AK on 14-5-2.
//  Copyright (c) 2014年 dekeqin. All rights reserved.
//

#ifndef IntelligentHome_NXConfig_h
#define IntelligentHome_NXConfig_h

//-------------------获取设备大小-------------------------


#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000)
//@available 在xcode 9 之后才能使用.xcode8 以及之前不能编译iOS11 以此判断xcode版本
// 标准系统状态栏高度 在 makeKeyAndVisible 后是正确的值
#define NX_STATUSBAR_HEIGHT ({float height ;if(@available(iOS 11.0, *)){ height = MAX(NX_KEY_WINDOW.safeAreaInsets.top,20.f);} else {height = 20.f;} height;})
//iphonex 下方虚拟home条  在 makeKeyAndVisible 后是正确的值
#define NX_BOTTOM_DANGER_HEIGHT ({float height ;if(@available(iOS 11.0, *)){ height = NX_KEY_WINDOW.safeAreaInsets.bottom;} else {height = 0;} height;})

#else

#define NX_STATUSBAR_HEIGHT 20.
#define NX_BOTTOM_DANGER_HEIGHT 0.

#endif

// 热点栏高度
#define NX_HOTSPOT_STATUSBAR_HEIGHT 20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NX_NAVIGATIONBAR_HEIGHT 44.0f
// 标签栏（UITabBarController.UITabBar）高度
#define NX_TABBAR_HEIGHT 49.0f
// 工具栏（UINavigationController.UIToolbar）高度
#define NX_TOOLBAR_HEIGHT 44.0f

#define NX_PICKERVIEW_HEIGHT 216.0f
#define NX_DATEPICKER_HEIGHT 216.0f
#define NX_CELL_DEFAULT_HEIGHT 44.0f

#define ITTAssert(condition, ...)                                                           \
    do                                                                                      \
    {                                                                                       \
        if (!(condition))                                                                   \
        {                                                                                   \
            [[NSAssertionHandler currentHandler]                                            \
                handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                                   file:[NSString stringWithUTF8String:__FILE__]            \
                             lineNumber:__LINE__                                            \
                            description:__VA_ARGS__];                                       \
        }                                                                                   \
    } while (0)
//----------------------APP----------------------------

//获取当前app显示的语言(本地化后的)
#define NX_APP_LANGUAGE [[[NSBundle mainBundle] preferredLocalizations] firstObject]


//----------------------系统----------------------------

//获取系统版本
#define NX_CURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]
//获取当前系统语言
#define NX_CURRENT_LANGUAGE [[NSLocale preferredLanguages] objectAtIndex:0]
//获取当前国家代号
#define NX_LOCAL_COUNTRY_CODE [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
//获取当前国家描述
#define NX_COUNTRY_DEC [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:NX_COUNTRY_CODE]



//判断是真机还是模拟器
#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif

//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
// compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define NX_RELEASE_SAFELY(__POINTER) \
    {                                \
        [__POINTER release];         \
        __POINTER = nil;             \
    }

//释放一个对象
#define NX_SAFE_DELETE(P)     \
    if (P)                    \
    {                         \
        [P release], P = nil; \
    }

#define NX_SAFE_RELEASE(x) \
    [x release];           \
    x = nil

//----------------------图片----------------------------

//读取本地图片
#define NXPNGPATH(NAME) [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]
#define NXJPGPATH(NAME) [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]
#define NXPATH(NAME, EXT) [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]
//定义UIImage对象
#define NXPNGIMAGE(NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define NXJPGIMAGE(NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define NXIMAGE(NAME, EXT) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define NXIMAGENAME(NAME) [UIImage imageNamed:NAME]

#define NXBOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define NXSYSTEMFONT(FONTSIZE) [UIFont systemFontOfSize:FONTSIZE]
#define NXFONT(NAME, FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE)]

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define NX_UIColorFromRGB(rgbValue)                                      \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
                     blue:((float)(rgbValue & 0xFF)) / 255.0             \
                    alpha:1.0]

#define NX_UIColorFromRGBA(rgbValue, a)                                  \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
                     blue:((float)(rgbValue & 0xFF)) / 255.0             \
                    alpha:a]


//带有RGBA的颜色设置
#define NX_COLOR(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

// 获取RGB颜色
#define NX_RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define NX_RGB(r, g, b) NX_RGBA(r, g, b, 1.0f)

//背景色
#define NX_BACKGROUND_COLOR [UIColor colorWithRed:242.0 / 255.0 green:236.0 / 255.0 blue:231.0 / 255.0 alpha:1.0]

//清除背景色
#define NX_CLEARCOLOR [UIColor clearColor]

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
#define NXLineBreakModeClip UILineBreakModeClip
#define NXTextAlignmentLeft UITextAlignmentLeft
#define NXTextAlignmentCenter UITextAlignmentCenter
#define NXTextAlignmentRight UITextAlignmentRight
#define NXLineBreakModeWordWrap UILineBreakModeWordWrap
#define NXLineBreakModeTailTruncation UILineBreakModeTailTruncation
#define NXLineBreakModeCharacterWrap UILineBreakModeCharacterWrap
#else

#define NXLineBreakModeClip NSLineBreakModeClip
#define NXTextAlignmentLeft NSTextAlignmentLeft
#define NXTextAlignmentCenter NSTextAlignmentCenter
#define NXTextAlignmentRight NSTextAlignmentRight
#define NXLineBreakModeWordWrap NSLineBreakByWordWrapping
#define NXLineBreakModeTailTruncation NSLineBreakByTruncatingTail
#define NXLineBreakModeCharacterWrap NSLineBreakByCharWrapping
#endif

//----------------------其他----------------------------

//设置View的tag属性
#define NX_VIEWWITHTAG(_OBJECT, _TAG) [_OBJECT viewWithTag:_TAG]

// G－C－D
#define NX_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define NX_MAIN(block) dispatch_async(dispatch_get_main_queue(), block)

// NSUserDefaults 实例化
#define NX_USER_DEFAULT [NSUserDefaults standardUserDefaults]

//由角度获取弧度 有弧度获取角度
#define NX_DEGREE_TO_RADIAN(x) (M_PI * (x) / 180.0)
#define NX_RADIAN_TO_DEGREE(radian) (radian * 180.0) / (M_PI)

//单例化一个类
#if __has_feature(objc_arc)

#define NXSINGLETON(_class_name_)                        \
                                                         \
    +(_class_name_ *)shared##Instance                    \
    {                                                    \
        static _class_name_ *shared##_class_name_ = nil; \
                                                         \
        static dispatch_once_t onceToken;                \
        dispatch_once(&onceToken, ^{                     \
            shared##_class_name_ = [[self alloc] init];  \
        });                                              \
                                                         \
        return shared##_class_name_;                     \
    }

#else

#define NXSINGLETON(_class_name_)                                                                       \
                                                                                                        \
    +(_class_name_ *)shared##Instance                                                                   \
    {                                                                                                   \
        static _class_name_ *shared##_class_name_ = nil;                                                \
                                                                                                        \
        static dispatch_once_t onceToken;                                                               \
        dispatch_once(&onceToken, ^{                                                                    \
            shared##_class_name_ = [[super allocWithZone:NULL] init];                                   \
        });                                                                                             \
                                                                                                        \
        return shared##_class_name_;                                                                    \
    }                                                                                                   \
                                                                                                        \
    +(id)allocWithZone : (NSZone *)zone { return [[self shared##Instance] retain]; }                    \
    -(id)copyWithZone : (NSZone *)zone { return self; }                                                 \
    -(id)retain { return self; }                                                                        \
    -(NSUInteger)retainCount { return NSUIntegerMax; /* so the singleton object cannot be released */ } \
    -(oneway void)release{}                                                                             \
                                                                                                        \
        - (id)autorelease                                                                               \
    {                                                                                                   \
        return self;                                                                                    \
    }

#endif

// -------------------------- OS -------------------------- //
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define NX_iOS7_OR_LATER \
    ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#else
#define NX_iOS7_OR_LATER (NO)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define NX_iOS8_OR_LATER \
    ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
#else
#define NX_iOS8_OR_LATER (NO)
#endif

#define NX_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define NX_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define NX_PORTRAIT (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
#define NX_LANDSCAPE (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))

// -------------------------- 常用宏常量 -------------------------- //
#define NX_KEY_WINDOW ([[UIApplication sharedApplication] keyWindow])

#define NX_MAIN_SCREEN_SCALE ([[UIScreen mainScreen] scale])

#define NX_APP_FRAME ([[UIScreen mainScreen] applicationFrame])
#define NX_APP_FRAME_HEIGHT ([[UIScreen mainScreen] applicationFrame].size.height)
#define NX_APP_FRAME_WIDTH ([[UIScreen mainScreen] applicationFrame].size.width)

#define NX_MAIN_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define NX_MAIN_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define NX_APP_TEMPORARY_DIRECTORY NSTemporaryDirectory()
#define NX_APP_CACHES_DIRECTORY NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
#define NX_APP_DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)

//
#define NXLocalizedString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//通用 callback
typedef void(^NXGenericCallback)(BOOL success, id result);


#endif
