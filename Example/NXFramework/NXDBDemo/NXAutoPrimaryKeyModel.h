//
//  NXAutoPrimaryKeyModel.h
//  NXDataBaseExample
//
//  Created by zll on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"

@interface NXAutoPrimaryKeyModel : NSObject<NXDBObjectProtocol>

@property (nonatomic, copy) NSString * key;

@end
