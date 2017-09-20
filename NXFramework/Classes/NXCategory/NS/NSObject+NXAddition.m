//
//  NSObject+NXAddition.m
//  NXlib
//
//  Created by AK on 3/28/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import "NSObject+NXAddition.h"
#import <objc/runtime.h>

NSString *const NXObjcTypeChar = @"char";
NSString *const NXObjcTypeInt = @"int";
NSString *const NXObjcTypeShort = @"short";
NSString *const NXObjcTypeInt32 = @"long int";
NSString *const NXObjcTypeInt64 = @"long long int";

NSString *const NXObjcTypeUChar = @"unsigned char";
NSString *const NXObjcTypeUInt = @"unsigned int";
NSString *const NXObjcTypeUShort = @"unsigned short";
NSString *const NXObjcTypeUInt32 = @"unsigned long int";
NSString *const NXObjcTypeUInt64 = @"unsigned long long int";

NSString *const NXObjcTypeFloat = @"float";
NSString *const NXObjcTypeDouble = @"double";

NSString *const NXObjcTypeBool = @"bool";

NSString *const NXObjcTypeCGPoint = @"CGPoint";
NSString *const NXObjcTypeCGSize = @"CGSize";
NSString *const NXObjcTypeCGRect = @"CGRect";

NSString *const NXObjcTypeNSDate = @"NSDate";

NSString *const NXObjcTypeNSData = @"NSData";

NSString *const NXObjcTypeNSString = @"NSString";

@implementation NSObject (NXAddition)

+ (NSDictionary *)nx_codableProperties
{
    // deprecated
    SEL deprecatedSelector = NSSelectorFromString(@"codableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: codableKeys method is no longer supported."
               " Use codableProperties instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableKeys");
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        NSLog(@"AutoCoding Warning: uncodableKeys method is no longer supported."
               " Use ivars, or synthesize your properties using non-KVC-compliant "
               "names to avoid coding them instead.");
    }
    deprecatedSelector = NSSelectorFromString(@"uncodableProperties");
    NSArray *uncodableProperties = nil;
    if ([self respondsToSelector:deprecatedSelector] || [self instancesRespondToSelector:deprecatedSelector])
    {
        uncodableProperties = [self valueForKey:@"uncodableProperties"];
        NSLog(@"AutoCoding Warning: uncodableProperties method is no longer "
              @"supported."
               " Use ivars, or synthesize your properties using non-KVC-compliant "
               "names to avoid coding them instead.");
    }

    __autoreleasing NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];

    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        // get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);

        // check if codable
        if (![uncodableProperties containsObject:key])
        {
            // get property type
            Class propertyClass = nil;
            char *typeEncoding = property_copyAttributeValue(property, "T");
            switch (typeEncoding[0])
            {
                case '@':
                {
                    if (strlen(typeEncoding) >= 3)
                    {
                        char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                        __autoreleasing NSString *name = @(className);
                        NSRange range = [name rangeOfString:@"<"];
                        if (range.location != NSNotFound)
                        {
                            name = [name substringToIndex:range.location];
                        }
                        propertyClass = NSClassFromString(name) ?: [NSObject class];
                        free(className);
                    }
                    break;
                }
                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B':
                {
                    propertyClass = [NSNumber class];
                    break;
                }
                case '{':
                {
                    propertyClass = [NSValue class];
                    break;
                }
            }
            free(typeEncoding);

            if (propertyClass)
            {
                // check if there is a backing ivar
                char *ivar = property_copyAttributeValue(property, "V");
                if (ivar)
                {
                    // check if ivar has KVC-compliant name
                    __autoreleasing NSString *ivarName = @(ivar);
                    if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        // no setter, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(ivar);
                }
                else
                {
                    // check if property is dynamic and readwrite
                    char *dynamic = property_copyAttributeValue(property, "D");
                    char *readonly = property_copyAttributeValue(property, "R");
                    if (dynamic && !readonly)
                    {
                        // no ivar, but setValue:forKey: will still work
                        codableProperties[key] = propertyClass;
                    }
                    free(dynamic);
                    free(readonly);
                }
            }
        }
    }
    free(properties);

    return codableProperties;
}

- (NSDictionary *)nx_codableProperties
{
    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!codableProperties)
    {
        codableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass nx_codableProperties]];
            subclass = [subclass superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];

        // make the association atomically so that we don't need to bother with an
        // @synchronize
        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return codableProperties;
}

+ (NSDictionary *)nx_storableProperties
{
    __autoreleasing NSMutableDictionary *storableProperties = [NSMutableDictionary dictionary];

    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        // get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);

        // get property type
        NSString *propertyType = nil;
        char *typeEncoding = property_copyAttributeValue(property, "T");
        switch (typeEncoding[0])
        {
            case '@':
            {
                if (strlen(typeEncoding) >= 3)
                {
                    char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                    __autoreleasing NSString *name = @(className);
                    NSRange range = [name rangeOfString:@"<"];
                    if (range.location != NSNotFound)
                    {
                        name = [name substringToIndex:range.location];
                    }
                    propertyType = name ?: NSStringFromClass([NSObject class]);
                    free(className);
                }
                break;
            }
            case 'c':
            {
                propertyType = NXObjcTypeChar;
                break;
            }
            case 'i':
            {
                propertyType = NXObjcTypeInt;
                break;
            }
            case 's':
            {
                propertyType = NXObjcTypeShort;
                break;
            }
            case 'l':
            {
                propertyType = NXObjcTypeInt32;
                break;
            }
            case 'q':
            {
                propertyType = NXObjcTypeInt64;
                break;
            }
            case 'C':
            {
                propertyType = NXObjcTypeUChar;
                break;
            }
            case 'I':
            {
                propertyType = NXObjcTypeUInt;
                break;
            }
            case 'S':
            {
                propertyType = NXObjcTypeUShort;
                break;
            }
            case 'L':
            {
                propertyType = NXObjcTypeUInt32;
                break;
            }
            case 'Q':
            {
                propertyType = NXObjcTypeUInt64;
                break;
            }
            case 'f':
            {
                propertyType = NXObjcTypeFloat;
                break;
            }
            case 'd':
            {
                propertyType = NXObjcTypeDouble;
                break;
            }
            case 'B':
            {
                propertyType = NXObjcTypeBool;
                break;
            }
            case '{':
            {
                __autoreleasing NSString *type = @(typeEncoding);
                NSRange range = [type rangeOfString:@"="];
                if (range.location != NSNotFound)
                {
                    type = [type substringWithRange:NSMakeRange(1, range.location - 1)];
                }
                propertyType = type;
                break;
            }
        }
        free(typeEncoding);

        if (propertyType)
        {
            // check if there is a backing ivar
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar)
            {
                // check if ivar has KVC-compliant name
                __autoreleasing NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                {
                    // no setter, but setValue:forKey: will still work
                    storableProperties[key] = propertyType;
                }
                free(ivar);
            }
            else
            {
                // check if property is dynamic and readwrite
                char *dynamic = property_copyAttributeValue(property, "D");
                char *readonly = property_copyAttributeValue(property, "R");
                if (dynamic && !readonly)
                {
                    // no ivar, but setValue:forKey: will still work
                    storableProperties[key] = propertyType;
                }
                free(dynamic);
                free(readonly);
            }
        }
    }
    free(properties);

    return storableProperties;
}

- (NSDictionary *)nx_storableProperties
{
    __autoreleasing NSDictionary *storableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!storableProperties)
    {
        storableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)storableProperties addEntriesFromDictionary:[subclass nx_storableProperties]];
            subclass = [subclass superclass];
        }
        storableProperties = [NSDictionary dictionaryWithDictionary:storableProperties];

        // make the association atomically so that we don't need to bother with an
        // @synchronize
        objc_setAssociatedObject([self class], _cmd, storableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return storableProperties;
}

@end
