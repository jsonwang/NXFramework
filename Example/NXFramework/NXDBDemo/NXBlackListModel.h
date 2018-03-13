//
//  GBlackListModel.h
//  GDataBaseExample
//
// Created by zll on 2018/3/12.
// Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDBObjectProtocol.h"

@interface NXBlackListModel : NSObject<NXDBObjectProtocol>

@property (nonatomic, copy) NSString* dataID ;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, strong) NSArray * blackField1;
@property (nonatomic, assign) BOOL  blackField2;
@property (nonatomic, copy  ) NSString * blackField3;
@end
