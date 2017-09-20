//
//  NXWIFISystemInfo.h
//  NXlib
//
//  Created by AK on 15/2/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

/**
 *  现在很多公司都在做免费WIFI，车站、公交、地铁、餐厅，只要是人员密集流动的地方就有WIFI
 *  本类是取一些网卡 路由信息的工具类
 */

#import <Foundation/Foundation.h>

@interface NXWIFISystemInfo : NSObject
{
}

/**
 *  获取IP地址(Wi-Fi情况下)
 */
+ (NSString *)localIPAddress;

/**
 *  获取网络信息(Wi-Fi情况下)
 */
- (NSDictionary *)getWIFIDic;


/**
 向 IOS 系统注册 批定WIFI路由名

 @param ssid WIFI路由名
 */
- (void)registerNetwork:(NSString *)ssid;

@end
