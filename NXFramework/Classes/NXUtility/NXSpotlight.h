//
//  NXSpotlight.h
//  NXlib
//
//  Created by AK on 16/4/26.
//  Copyright © 2016年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *   ios 9.0+ spotlight 使用
    e.g.
         // Weakly Linked判断
         if ([CSSearchableItemAttributeSet class])
         {
                 //应用内搜索，想搜索到多少个界面就要创建多少个set
 ，每个set都要对应一个item ContentType 是点击后取到的值
                 CSSearchableItemAttributeSet *attributeSet =
                 [[CSSearchableItemAttributeSet alloc]
 initWithItemContentType:@"vid=5200&uid=1000"];
                 // 搜索结果中显示的标题
                 attributeSet.title = @"2016年";

                 // 搜索结果中显示的详情
                 attributeSet.contentDescription = @"是不是要给他打电话了";
                 attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage
 imageNamed:@"33333.png"]);
                 attributeSet.phoneNumbers = @[ @"13167578333" ];
                 //开启显示电话按钮，若phoneNumbers为空，则开启了该权限也不会显示电话按钮
                 attributeSet.supportsPhoneCall = @(YES);
                 //关键词，当用户输入以下字符串时，相关内容会被检索到
                 attributeSet.keywords = [NSArray arrayWithObjects:@"287",
 @"971", @"051", nil];
                 [NXSpotlight createSearchIndex:@[ attributeSet ]];
         }

 注意的问题XXXX
    当我们更新完Spotlight索引的缩略图之后 发现根本换成新的图片。目前没有好的办法
 只能重启手机

 当点击 后目前只能唤醒APP 并没有接收参数 在 appdelegate 中加放如下方法
 可接收到参数
     #pragma mark - Spotlight delegate
     - (BOOL)application:(nonnull UIApplication *)application
     continueUserActivity:(nonnull NSUserActivity *)userActivity
     restorationHandler:(nonnull void (^)(NSArray
 *__nullable))restorationHandler
     {
         NSLog(@"idetifier %@",
 userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"]);
         return YES;
     }
 */

@interface NXSpotlight : NSObject

/**
 *  添加索引数据 注意方法只能在 ios 9.0+中使用
 *
 *  @param dataSources 数据数组 里面存放 CSSearchableItemAttributeSet 对象
 */
+ (void)createSearchIndex:(NSArray *)dataSources NS_AVAILABLE_IOS(9_0);

@end
