//
//  NXCoreBluetoothTool.m
//  NXlib
//
//  Created by AK on 15/4/29.
//  Copyright (c) 2015年 AK. All rights reserved.
//

#import "NXCoreBluetoothTool.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface NXCoreBluetoothTool ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation NXCoreBluetoothTool

- (id)init
{
    if (self = [super init])
    {
        CBCentralManager *manager;
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

        NSDictionary *dic =
            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                                                       CBCentralManagerScanOptionAllowDuplicatesKey, nil];

        [manager scanForPeripheralsWithServices:nil options:dic];
    }

    return self;
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI

{
    //	if(![_dicoveredPeripherals containsObject:peripheral])
    //		[_dicoveredPeripherals addObject:peripheral];

    NSLog(@"dicoveredPeripherals:%@", peripheral);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {}
@end
