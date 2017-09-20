//
//  NXLogManager.h
//  Philm
//
//  Created by AK on 2017/2/24.
//  Copyright © 2017年 yoyo. All rights reserved.
//


/**
    对设备的LOG 信息管理 保存和取日志文件
 
 */
#import <Foundation/Foundation.h>

@interface NXLogManager : NSObject


/**
   调用此方法后 会在把设备中的日志保存到沙盒中 $/Documents/appLog/nx_log.txt
 */
+ (void)redirectNSlogToDocumentFolder;


/**
  取保存日志的路径

 @return log path
 */
+ (NSString *)getLogFilePath;
@end
