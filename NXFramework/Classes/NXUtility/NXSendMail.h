//
//  NXSendMail.h
//  YOSticker
//
//  Created by AK on 16/7/16.
//  Copyright © 2016年 Catch app. All rights reserved.
//

/**
 *  在程序内发送邮件
 */

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@interface NXSendMail : NSObject

// XXXX要使用单例,在ARC下 setMailComposeDelegate 会crash
+ (NXSendMail *)sharedInstance;

/**
 *  发送邮件
 *
 *  @param recipients  收件人
 *  @param subject     标题
 *  @param messageBody 正文
 *  @param isHTML      是否为HTML 格式 e.g.
 * @"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES
 */
+ (void)setMailrecipients:(NSArray *)recipients
                  subject:(NSString *)subject
              messageBody:(NSString *)messageBody
                   isHTML:(BOOL)isHTML;

- (BOOL)isSendMail;
@end
