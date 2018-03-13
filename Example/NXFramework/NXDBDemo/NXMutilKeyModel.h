//
//  GMutilKeyModel.h
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"
/// 多主建
@interface NXMutilKeyModel : NSObject<NXDBObjectProtocol>
@property (nonatomic, copy  ) NSString * primaryKey1;
@property (nonatomic, copy  ) NSString * primaryKey3;
@property (nonatomic, assign) int  primaryKey2;
@property (nonatomic, strong) NSString * other;
@end
