//
//  NXKeychainTools.m
//  NXlib
//
//  Created by AK on 14-5-18.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NXKeychainTools.h"

// http://www.jianshu.com/p/b0babe3165d2

@implementation NXKeychainTools

+ (NSString *)getStringFromKeychainForKey:(NSString *)keyString error:(NSError **)error
{
    //传入KEY为空返回 error
    if (!keyString)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:-2000 userInfo:nil];
        }
        return @"";
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSArray *keys = [[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects =
        [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, keyString, [NXSystemInfo bundleID], nil];

    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];

    CFTypeRef attributeResultRef;
    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];

    OSStatus status = SecItemCopyMatching((CFDictionaryRef)attributeQuery, &attributeResultRef);
 
    if (status != noErr)
    {
        if (error != nil && status != errSecItemNotFound)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:status userInfo:nil];
        }

        return nil;
    }

    CFTypeRef resultDataRef;
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

    status = SecItemCopyMatching((CFDictionaryRef)passwordQuery, &resultDataRef);

    if (status != noErr)
    {
        if (status == errSecItemNotFound)
        {
            if (error != nil)
            {
                *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:-1999 userInfo:nil];
            }
        }
        else
        {
            if (error != nil)
            {
                *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:status userInfo:nil];
            }
        }
        
        //add by ak 置空防止内存泄露
        passwordQuery = nil;

        return nil;
    }

    NSString *savaString = nil;

    NSData *resultData = (__bridge_transfer NSData *)resultDataRef;

    if (resultData)
    {
        savaString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    else
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:-1999 userInfo:nil];
        }
    }

    return savaString;
}

+ (BOOL)saveStringToKeychainWithKeyString:(NSString *)keyString
                           saveDataString:(NSString *)savaDataString
                           updateExisting:(BOOL)updateExisting
                                    error:(NSError **)error
{
    if (!keyString || !savaDataString)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:-2000 userInfo:nil];
        }
        return NO;
    }

    NSError *getError = nil;
    NSString *existingString = [NXKeychainTools getStringFromKeychainForKey:keyString error:&getError];

    if ([getError code] == -1999)
    {
        getError = nil;

        [NXKeychainTools deleteStringFromKeychain:keyString error:&getError];

        if ([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
            return NO;
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    OSStatus status = noErr;

    if (existingString)
    {
        if (![existingString isEqualToString:savaDataString] && updateExisting)
        {
            NSArray *keys = [[NSArray alloc]
                initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil];

            NSArray *objects =
                [[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, [NXSystemInfo bundleID],
                                                 [NXSystemInfo bundleID], keyString, nil];

            NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];

            status = SecItemUpdate(
                (CFDictionaryRef)query,
                (CFDictionaryRef)
                    [NSDictionary dictionaryWithObject:[savaDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                forKey:(NSString *)kSecValueData]);
        }
    }
    else
    {
        NSArray *keys = [[NSArray alloc]
            initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil];

        NSArray *objects = [[NSArray alloc]
            initWithObjects:(NSString *)kSecClassGenericPassword, [NXSystemInfo bundleID], [NXSystemInfo bundleID],
                            keyString, [savaDataString dataUsingEncoding:NSUTF8StringEncoding], nil];

        NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];

        status = SecItemAdd((CFDictionaryRef)query, NULL);
    }

    if (status != noErr)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:status userInfo:nil];
        }

        return NO;
    }

    return YES;
}

+ (BOOL)deleteStringFromKeychain:(NSString *)keyString error:(NSError **)error
{
    if (!keyString)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:-2000 userInfo:nil];
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSArray *keys = [[NSArray alloc]
        initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc]
        initWithObjects:(NSString *)kSecClassGenericPassword, keyString, [NXSystemInfo bundleID], kCFBooleanTrue, nil];

    NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];

    OSStatus status = SecItemDelete((CFDictionaryRef)query);

    if (status != noErr)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain:[NXSystemInfo bundleID] code:status userInfo:nil];
        }

        return NO;
    }

    return YES;
}

@end
