//
//  PLRequest.m
//  NXNetworkManager
//
//  Created by yoyo on 2017/9/7.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import "PLRequest.h"
#import "NXNWConfig.h"
@implementation PLRequest

-(instancetype) initWithUrl:(NSString *)url{

    self = [super initWithUrl:url];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [NXNWConfig shareInstanced].baseUrl = @"http://data.philm.cc/sticker/2017/v18/";
            [NXNWConfig shareInstanced].globalParams.addString(@"param1",@"1234");
            [NXNWConfig shareInstanced].globalParams.addString(@"param2",@"1234");
            [NXNWConfig shareInstanced].globalParams.addString(@"param3",@"1234");
            [NXNWConfig shareInstanced].globalParams.addString(@"param4",@"1234");
            
            [NXNWConfig shareInstanced].globalHeaders.addString(@"header1",@"1234");
            [NXNWConfig shareInstanced].globalHeaders.addString(@"header2",@"1234");
            [NXNWConfig shareInstanced].globalHeaders.addString(@"header3",@"1234");
            [NXNWConfig shareInstanced].globalHeaders.addString(@"header4",@"1234");
            
            [NXNWConfig shareInstanced].consoleLog = YES;
        });
        
        self.config =[NXNWConfig shareInstanced];
        
    }
    
    return self;
}
@end
