//
//  NXUMTruck.h
//  NXlib
//
//  Created by AK on 14/12/25.
//  Copyright (c) 2014年 AK. All rights reserved.
/**
 *
 1.serve advertisements within the app
 服务应用中的广告。如果你的应用中集成了广告的时候，你需要勾选这一项。

 2.Attribute this app installation to a previously served advertisement.
 跟踪广告带来的安装。如果你使用了第三方的工具来跟踪广告带来的激活以及一些其他事件，但是应用里并没有展示广告你需要勾选这一项。

 3.Attribute an action taken within this app to a previously served
 advertisement
 跟踪广告带来的用户的后续行为。如果你使用了第三方的工具来跟踪广告带来的激活以及一些其他事件，但是应用里并没有展示广告你需要勾选第2项和第3项。
 下边还有一项

 4.Limit Ad Tracking setting in iOS
 这一项下的内容其实就是对你的应用使用idfa的目的做下确认，只要你选择了采集idfa，那么这一项都是需要勾选的。

  xxxxx 如果程序内没有广告，选YES 和 2，3，4 提交审核

 5. e.g. [YOYOUMTruck umtruck:@"xxxxxxx"]; xxxxx 是你的账号 appKEyp
 */

#import <Foundation/Foundation.h>

@interface NXUMTruck : NSObject
{
}

/**
 *  发truck 统计和分析流量来源、内容使用、用户属性和行为数据
 *
 *  @param youAppKey 到后台找 http://umtrack.com/apps/
 */
+ (void)umtruck:(NSString *)youAppKey;

@end
