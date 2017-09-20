//
//  NXNWConfig.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/7.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "NXNWConfig.h"
#import "NXNWCerter.h"
@interface NXNWConfig()

@end

@implementation NXNWConfig

+ (instancetype)shareInstanced
{
    static NXNWConfig *nx_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nx_config = [[NXNWConfig alloc] init];
    });
    
    return nx_config;
}

- (instancetype) init{

    self = [super init];
    if (self) {
    
        self.callbackQueue = dispatch_get_main_queue();
    }
    return self;
}

- (id<NXContainerProtol> )globalParams{

    if (_globalParams == nil) {
        
        _globalParams = [[NXContainer alloc] init];
    }
    
    return _globalParams;

}

- (id<NXContainerProtol>)globalHeaders{

    if (_globalHeaders == nil) {
        
        _globalHeaders = [[NXContainer alloc] init];
    }
    return _globalHeaders;
}
- (void)addSSLPinningURL:(NSString *)url{

    [[NXNWCerter shareInstanced] addSSLPinningURL:url];
}
- (void)addSSLPinningCert:(NSData *)cert{

    [[NXNWCerter shareInstanced] addSSLPinningCert:cert];
}
- (void)addTwowayAuthenticationPKCS12:(NSData *)p12 keyPassword:(NSString *)password{

    [[NXNWCerter shareInstanced] addTwowayAuthenticationPKCS12:p12 keyPassword:password];
}
@end

@interface NXContainer ()

@property(nonatomic,strong)NSMutableDictionary * containerDic;
@end

@implementation NXContainer


- (NSMutableDictionary *)containerDic{
    
    if (_containerDic == nil) {
        
        _containerDic = [[NSMutableDictionary alloc] init];
    }
    return _containerDic;
}
#pragma mark - NXContainerProtol

- (NSDictionary *)containerConfigDic{
   
    return [[NSDictionary alloc] initWithDictionary:self.containerDic];
}

- (NXContainerAddIntegerBlock)addInteger{
    
    return ^(NSInteger value,NSString * key){
        
        NSString * value_ = [NSString stringWithFormat:@"%ld",(long)value];
        
        return self.addString(value_,key);
    };
}
- (NXContainerAddDoubleBlock)addDouble{
    
    return ^(double value,NSString * key){
        
        NSString * value_ = [NSString stringWithFormat:@"%f",value];
        return self.addString(value_,key);
    };
}
- (NXContainerAddStringgerBlock)addString{
    
    return ^(NSString * value,NSString * key){
        
        NSAssert(key, @" param key can not nil");
        
        if (value.length <= 0) {
            value = @"";
        }
        [self.containerDic setObject:value forKey:key];
        return self;
    };
}
@end
