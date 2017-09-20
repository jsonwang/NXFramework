//
//  NXSwizzleManager.m
//  NXlib
//
//  Created by AK on 15/9/26.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NXSwizzleManager.h"
#import "Aspects.h"

@implementation NXSwizzleManager

+ (void)createAllHooks
{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> info) {
                                   //用户统计代码写在此处
                                   NSLog(@"[ASPECT] inject in class instance:%@", [info instance]);

                               }
                                    error:NULL];
    //
    [UIControl aspect_hookSelector:@selector(sendAction:to:forEvent:)
                       withOptions:AspectPositionBefore
                        usingBlock:^(id<AspectInfo> info) {
                            //用户统计代码写在此处
                            NSLog(@"btn onclick %@", [info instance]);
                        }
                             error:NULL];

    // other hooks ... goes here
    //...
}
@end
