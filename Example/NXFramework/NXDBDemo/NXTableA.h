//
//  GTableA.h
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"
#import <YYKit/YYKit.h>

@interface NXSubTableA : NSObject
@property (nonatomic, strong) NSString *key;
@end

@interface NXTableA : NSObject<NXDBObjectProtocol>

@property (nonatomic, strong) NSArray * datas;
@property (nonatomic, strong) NXSubTableA * subA;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSData * realData;
@property (nonatomic, strong) NSDictionary * dict;
@property (nonatomic, strong) NSMutableArray * array;

@end
