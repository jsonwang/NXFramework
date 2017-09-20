//
//  NSFileWrapper+Copying.m
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSFileWrapper+NXCategory.h"

@implementation NSFileWrapper (NXCategory)

- (NSFileWrapper *)nx_fileWrapperByDeepCopying
{
    if ([self isDirectory])
    {
        NSMutableDictionary *subFileWrappers = [NSMutableDictionary dictionary];

        [self.fileWrappers
            enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSFileWrapper *fileWrapper, BOOL *stop) {
                NSFileWrapper *copyWrapper = [fileWrapper nx_fileWrapperByDeepCopying];
                [subFileWrappers setObject:copyWrapper forKey:fileName];
            }];

        NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:subFileWrappers];

        return fileWrapper;
    }

    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:self.regularFileContents];
    return fileWrapper;
}

@end
