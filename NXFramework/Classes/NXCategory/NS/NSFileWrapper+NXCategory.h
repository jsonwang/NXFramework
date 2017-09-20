//
//  NSFileWrapper+Copying.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileWrapper (NXCategory)
/**
 Creates a copy of the receiver by deep copying all contained sub filewrappers.
 */
- (NSFileWrapper *)nx_fileWrapperByDeepCopying;

@end
