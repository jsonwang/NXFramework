//
//  NSJSONSerialization+Utils.h
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Utils)
+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName inBundle:(NSBundle *)bundle;

+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName;
@end
