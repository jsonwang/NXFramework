//
//  NXPhotoConfig.m
//  AFNetworking
//
//  Created by liuming on 2018/7/6.
//

#import "NXPhotoConfig.h"
static NXPhotoConfig * config_obj  = nil;

@implementation NXPhotoConfig
+ (instancetype) shareInstanced
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config_obj == nil)
        {
            config_obj = [[NXPhotoConfig alloc] init];
        }
    });
    
    return config_obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
