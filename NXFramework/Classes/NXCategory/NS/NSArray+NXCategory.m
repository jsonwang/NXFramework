//
//  NSArray+FirstObject.m
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSArray+NXCategory.h"

@implementation NSArray (NXCategory)

- (BOOL)nx_isNotEmpty
{
    return (![(NSNull *)self isEqual:[NSNull null]] && [self isKindOfClass:[NSArray class]] && self.count > 0);
}

- (NSArray *)nx_sortNumArray
{
    NSArray *result = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int a = [obj1 intValue];
        int b = [obj2 intValue];
        if (a > b)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    return result;
}

- (NSArray *)nx_getUnduplicatedElement
{
    NSSet *set = [NSSet setWithArray:self];
    NSArray *result = [set allObjects];
    return result;
}

- (NSArray *)nx_reverseArray
{
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];

    for (id element in enumerator)
    {
        [arrayTemp addObject:element];
    }

    return arrayTemp;
}

- (BOOL)nx_isContainsString:(NSString *)string
{
    for (NSString *element in self)
    {
        if ([element isKindOfClass:[NSString class]] && [element isEqualToString:string])
        {
            return YES;
        }
    }

    return NO;
}

@end
