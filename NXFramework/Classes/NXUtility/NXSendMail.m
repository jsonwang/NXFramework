//
//  NXSendMail.m
//  YOSticker
//
//  Created by AK on 16/7/16.
//  Copyright © 2016年 Catch app. All rights reserved.
//

#import "NXSendMail.h"
#import "NXConfig.h"
#import "UIViewController+NXAddiction.h"

@interface NXSendMail ()<MFMailComposeViewControllerDelegate>
{
    BOOL isSendEmail;
}

@end

@implementation NXSendMail

NXSINGLETON(NXSendMail);

+ (void)setMailrecipients:(NSArray *)recipients
                  subject:(NSString *)subject
              messageBody:(NSString *)messageBody
                   isHTML:(BOOL)isHTML
{
    if ([MFMailComposeViewController canSendMail])
    {
        [[self sharedInstance] sendEmailActionRecipients:recipients
                                                 subject:subject
                                             messageBody:messageBody
                                                  isHTML:isHTML];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"请去设置->邮件,通讯录,日历->添加账户 "
                                            @"设置你常用邮件,感谢您的反馈"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (BOOL)isSendMail { return isSendEmail; }
- (void)sendEmailActionRecipients:(NSArray *)recipients
                          subject:(NSString *)subject
                      messageBody:(NSString *)messageBody
                           isHTML:(BOOL)isHTML
{
    if (isSendEmail == NO)
    {
        isSendEmail = YES;
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:self];

        //主题
        [mailCompose setSubject:subject];

        //收件人
        [mailCompose setToRecipients:recipients];
        //抄送人
        //    [mailCompose setCcRecipients:@[ @"287971051@qq.com" ]];
        //密抄送
        //    [mailCompose setBccRecipients:@[ @"287971051@qq.com" ]];

        //正文是否为HTML格式
        [mailCompose setMessageBody:messageBody isHTML:isHTML];
        // 如使用HTML格式，则为以下代码
        //    [mailCompose
        //    setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>"
        //    isHTML:YES];

        /**
         *  添加附件
         */
        //    UIImage *image = [UIImage imageNamed:@"image"];
        //    NSData *imageData = UIImagePNGRepresentation(image);
        //    [mailCompose addAttachmentData:imageData mimeType:@""
        //    fileName:@"custom.png"];
        //
        //    NSString *file = [[NSBundle mainBundle] pathForResource:@"test"
        //    ofType:@"pdf"];
        //    NSData *pdf = [NSData dataWithContentsOfFile:file];
        //    [mailCompose addAttachmentData:pdf mimeType:@""
        //    fileName:@"7天精通IOS233333"];

        //        [[UIApplication sharedApplication]
        //                .keyWindow.rootViewController
        //                presentViewController:mailCompose
        //                                                           animated:YES
        //                                                         completion:nil];
        [[UIViewController nx_currentViewController] presentViewController:mailCompose animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0)
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"发送邮件取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存到草稿箱");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送邮件");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Failed to send E-mail"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else
    {
#pragma mark-- 这两种方法在 ios7.0上面 dissmiss不掉
//        [[UIApplication sharedApplication]
//                .keyWindow.rootViewController
//                dismissViewControllerAnimated:YES
//                                                                 completion:nil];
//        [[UIViewController currentViewController]
//        dismissViewControllerAnimated:YES completion:nil];
#pragma mark--
        [controller dismissViewControllerAnimated:YES completion:nil];
        isSendEmail = NO;
    }
}

@end
