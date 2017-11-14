//
//  NSBundle+NXFramework.m
//  Pods-NXFramework_Example
//
//  Created by liuming on 2017/11/14.
//

#import "NSBundle+NXCategory.h"
#import "../../NXObject.h"
@implementation NSBundle (NXCategory)


+ (NSBundle *)NXFramworkBundle
{
    static NSBundle * NXFramworkBundle = nil;
    if(NXFramworkBundle == nil)
    {
        NXFramworkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[NXObject class]] pathForResource:@"NXFramework" ofType:@"bundle"]];
    }
    return NXFramworkBundle;
}
+(NSString *)nx_pathForResource:(NSString *)name ofType:(NSString *)type
{
    return [[self NXFramworkBundle] pathForResource:name ofType:type];
}
+ (NSString *)nx_localizedStringForKey:(NSString *)key
{
    return [self nx_localizedStringForKey:key value:nil];
}
+ (NSString *)nx_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    return [self nx_localizedStringForKey:key value:value table:nil];
}
+(NSString *)nx_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)talbelName{
    
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle NXFramworkBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:talbelName];
}
@end
