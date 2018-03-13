//
//  NXAppsDataViewModel.h
//  GOACloud
//
//  Created by ꧁༺ Yuri ༒ Boyka™ ༻꧂ on 2018/3/12.
//  Copyright © 2018年 NXDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "NXDBObjectProtocol.h"

@interface NXAppsDataViewModel : NSObject<NXDBObjectProtocol,YYModel>
@property (nonatomic, strong) NSString  *dataID;
@property (nonatomic, copy) NSString  *fields;
@property (nonatomic, assign) int  dataGroup;
@property (nonatomic, assign) NSInteger  dataIndex;
@property (nonatomic,   copy) NSString * name;
@property (nonatomic, assign) NSInteger  show;
@property (nonatomic,   copy) NSString * templateID;
@property (nonatomic, assign) long long   timestamp;
@property (nonatomic, assign) NSInteger  type;
@property (nonatomic,   copy) NSString * list;
@property (nonatomic,   copy) NSString * myProperty;
@end


