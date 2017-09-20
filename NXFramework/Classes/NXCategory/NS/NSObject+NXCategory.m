//
//  NSObject+NXCategory.m
//  YOYO
//
//  Created by AK on 5/12/14.
//
//
/*
 *   call [self fullDescription];
 */

#import "NSObject+NXCategory.h"
#import <objc/runtime.h>

@implementation NSObject (NXCategory)

+ (BOOL)nx_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origSel)
    {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }

    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod)
    {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }

    class_addMethod(self, origSel, class_getMethodImplementation(self, origSel), method_getTypeEncoding(origMethod));
    class_addMethod(self, altSel, class_getMethodImplementation(self, altSel), method_getTypeEncoding(altMethod));

    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));

    return YES;
}

+ (BOOL)nx_swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel
{
    Class c = object_getClass((id)self);
    return [c nx_swizzleMethod:origSel withMethod:altSel];
}

- (NSString *)nx_fullDescription
{
    NSString *despStr = @"\n";
    Class cls = [self class];
    while (cls != [NSObject class])
    {
        /*判断是自身类还是父类*/
        BOOL bIsSelfClass = (cls == [self class]);
        unsigned int iVarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int sharedVarCount = 0;
        Ivar *ivarList =
            bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL; /*变量列表，含属性以及私有变量*/
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount); /*属性列表*/
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;

        for (int i = 0; i < sharedVarCount; i++)
        {
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
            id varValue = [self valueForKey:key];
            if (varValue)
            {
                despStr = [despStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, varValue]];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return despStr;
}

- (BOOL)nx_isNull:(id)object
{
    if ([object isEqual:[NSNull null]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object == nil)
    {
        return NO;
    }
    return YES;
}

@end
