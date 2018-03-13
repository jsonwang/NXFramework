//
//  NSJSONSerialization+Utils.m
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import "NSJSONSerialization+Utils.h"

@implementation NSJSONSerialization (Utils)
+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName
{
    return [self JSONObjectWithContentsOfFile:fileName inBundle:[NSBundle mainBundle]];
}

+ (id)JSONObjectWithContentsOfFile:(NSString*)fileName inBundle:(NSBundle *)bundle
{
    NSString *filePath = [bundle pathForResource:[fileName stringByDeletingPathExtension]
                                          ofType:[fileName pathExtension]];
    
    NSAssert(filePath, @"JSONFile: File not found");
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    
    if (error) NSLog(@"JSONFile error: %@", error);
    
    if (error != nil) return nil;
    
    return result;
}
@end
