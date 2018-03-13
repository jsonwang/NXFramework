//
//  SQLiteReserveModel.h
//  GDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"

@interface SQLiteReserveModel : NSObject<NXDBObjectProtocol>

@property (nonatomic, assign) NSInteger  index;
@property (nonatomic, copy  ) NSString * group;
@property (nonatomic, copy  ) NSString * add;
@property (nonatomic, copy  ) NSString * as;
@property (nonatomic, copy  ) NSString * desc;

@end
