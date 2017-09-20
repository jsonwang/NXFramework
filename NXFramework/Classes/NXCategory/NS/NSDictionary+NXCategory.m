//
//  NSDictionary+Error.m
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSDictionary+NXCategory.h"

#import "NSString+NXCategory.h"

@implementation NSDictionary (NXCategory)
- (BOOL)nx_isNotEmpty
{
    return (![(NSNull *)self isEqual:[NSNull null]] && [self isKindOfClass:[NSDictionary class]] && self.count > 0);
}

- (NSArray *)nx_arrayForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return nil;
    }
    else
    {
        if ([object isKindOfClass:[NSArray class]])
        {
            return object;
        }
    }
    return nil;
}

- (NSDictionary *)nx_dictionaryForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return nil;
    }
    else
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            return object;
        }
    }
    return nil;
}

- (NSString *)nx_stringForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return @"";
    }
    else
    {
        if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object stringValue];
        }
        else if ([object isKindOfClass:[NSString class]])
        {
            return (NSString *)object;
        }
    }
    return @"";
}

- (NSInteger)nx_integerForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return 0;
    }
    else
    {
        if ([object isKindOfClass:[NSString class]])
        {
            return [(NSString *)object integerValue];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object integerValue];
        }
    }
    return 0;
}

- (int)nx_intForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return (int)0;
    }
    else
    {
        if ([object isKindOfClass:[NSString class]])
        {
            return [(NSString *)object intValue];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object intValue];
        }
    }
    return (int)0;
}

- (float)nx_floatForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return (float)0;
    }
    else
    {
        if ([object isKindOfClass:[NSString class]])
        {
            return [(NSString *)object floatValue];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object floatValue];
        }
    }
    return (float)0;
}

- (double)nx_doubleForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return (double)0;
    }
    else
    {
        if ([object isKindOfClass:[NSString class]])
        {
            return [(NSString *)object doubleValue];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object doubleValue];
        }
    }
    return (double)0;
}

- (BOOL)nx_boolForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]])
    {
        return NO;
    }
    else
    {
        if ([object isKindOfClass:[NSString class]])
        {
            return [(NSString *)object boolValue];
        }
        else if ([object isKindOfClass:[NSNumber class]])
        {
            return [(NSNumber *)object boolValue];
        }
    }
    return NO;
}

- (NSString *)nx_paramString
{
    NSMutableArray *paramPairs = [NSMutableArray array];

    for (NSString *key in [self keyEnumerator])
    {
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            [paramPairs addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSString *)value nx_URLEncoded]]];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            [paramPairs addObject:[NSString stringWithFormat:@"%@=%@", key, [(NSNumber *)value stringValue]]];
        }
    }

    return [paramPairs componentsJoinedByString:@"&"];
}

@end
