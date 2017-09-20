//
//  NSString+Extensions.m
//  NXLib
//
//  Created by AK on 14-3-27.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSString+NXCategory.h"
#import <CommonCrypto/CommonDigest.h>

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif

@interface NSString (UsefulStuffPrivate)

+ (BOOL)nx_stringIsPalindrome:(NSString *)aString position:(NSInteger)position;

@end

@implementation NSString (NXCategory)

+ (BOOL)nx_isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }

    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }

    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"])
    {
        return YES;
    }

    return NO;
}

+ (NSString *)nx_formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

+ (NSString *)nx_MIMETypeForFileExtension:(NSString *)extension
{
    CFStringRef typeForExt =
        UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *result = (__bridge NSString *)UTTypeCopyPreferredTagWithClass(typeForExt, kUTTagClassMIMEType);
    CFRelease(typeForExt);
    if (!result)
    {
        return @"application/octet-stream";
    }

    return result;
}

+ (NSString *)nx_fileTypeDescriptionForFileExtension:(NSString *)extension
{
    CFStringRef typeForExt =
        UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *result = (__bridge NSString *)UTTypeCopyDescription(typeForExt);
    CFRelease(typeForExt);
    return result;
}

+ (NSString *)nx_universalTypeIdentifierForFileExtension:(NSString *)extension
{
    return (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                      (__bridge CFStringRef)extension, NULL);
}

+ (NSString *)nx_fileExtensionForUniversalTypeIdentifier:(NSString *)UTI
{
    return (__bridge NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)(UTI),
                                                                kUTTagClassFilenameExtension);
}

+ (int)nx_countWords:(NSString *)string
{
    int strlength = 0;

    char *p = (char *)[string cStringUsingEncoding:NSUnicodeStringEncoding];

    for (int i = 0; i < [string lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;

            strlength++;
        }

        else
        {
            p++;
        }
    }

    return (strlength + 1) / 2;
}

+ (NSString *)nx_clipContentTextToLimit:(NSString *)string
{
    NSString *str = [string copy];
    if ([NSString nx_countWords:str] > 10)
    {
        for (NSUInteger i = str.length; i > 0; i--)
        {
            if ([NSString nx_countWords:[str substringToIndex:i]] <= 10)
            {
                return [str substringToIndex:i];
            }
        }
    }
    return str;
}

- (id)nx_jsonValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (jsonObject != nil && error == nil)
    {
        return jsonObject;
    }
    else
    {
        // 解析错误
        return nil;
    }
}

- (BOOL)nx_containsString:(NSString *)other
{
    NSRange range = [self rangeOfString:other];
    return range.location == NSNotFound;
}

+ (BOOL)nx_stringIsPalindrome:(NSString *)aString { return [NSString nx_stringIsPalindrome:aString position:0]; }
+ (BOOL)nx_stringIsPalindrome:(NSString *)aString position:(NSInteger)position
{
    NSString *_string = [NSString stringWithString:aString];
    NSInteger _position = position;

    if (!_string)
    {
        return NO;
    }

    NSInteger stringLength = [_string length];
    NSString *firstChar = [[_string substringToIndex:_position] substringToIndex:1];
    NSString *lastChar = [[_string substringToIndex:(stringLength - 1 - _position)] substringToIndex:1];

    if (_position > (stringLength / 2))
    {
        return YES;
    }

    if (![firstChar isEqualToString:lastChar])
    {
        return NO;
    }

    return [NSString nx_stringIsPalindrome:_string position:(_position + 1)];
}

- (BOOL)nx_isPalindrome { return [NSString nx_stringIsPalindrome:self]; }
- (NSString *)nx_reverse
{
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];

    for (int i = ((int)[self length] - 1); i >= 0; i -= 1)
    {
        [reversedString appendString:[NSString stringWithFormat:@"%C", [self characterAtIndex:i]]];
    }

    return reversedString;
}

- (NSNumber *)nx_stringToNSNumber
{
    NSNumberFormatter *tmpFormatter = [[NSNumberFormatter alloc] init];
    [tmpFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *theNumber = [tmpFormatter numberFromString:self];
    return theNumber;
}

- (BOOL)nx_conformsToUniversalTypeIdentifier:(NSString *)conformingUTI
{
    return UTTypeConformsTo((__bridge CFStringRef)(self), (__bridge CFStringRef)conformingUTI);
}

- (BOOL)nx_isMovieFileName
{
    NSString *extension = [self pathExtension];

    // without extension we cannot know
    if (![extension length])
    {
        return NO;
    }

    NSString *uti = [NSString nx_universalTypeIdentifierForFileExtension:extension];

    return [uti nx_conformsToUniversalTypeIdentifier:@"public.movie"];
}

- (BOOL)nx_isAudioFileName
{
    NSString *extension = [self pathExtension];

    // without extension we cannot know
    if (![extension length])
    {
        return NO;
    }

    NSString *uti = [NSString nx_universalTypeIdentifierForFileExtension:extension];

    return [uti nx_conformsToUniversalTypeIdentifier:@"public.audio"];
}

- (BOOL)nx_isImageFileName
{
    NSString *extension = [self pathExtension];

    // without extension we cannot know
    if (![extension length])
    {
        return NO;
    }

    NSString *uti = [NSString nx_universalTypeIdentifierForFileExtension:extension];

    return [uti nx_conformsToUniversalTypeIdentifier:@"public.image"];
}

- (BOOL)nx_isHTMLFileName
{
    NSString *extension = [self pathExtension];

    // without extension we cannot know
    if (![extension length])
    {
        return NO;
    }

    NSString *uti = [NSString nx_universalTypeIdentifierForFileExtension:extension];

    return [uti nx_conformsToUniversalTypeIdentifier:@"public.html"];
}

- (CGFloat)nx_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
        textSize =
            [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                            attributes:attributes
                               context:nil]
                .size;
    }
    else
    {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
    textSize =
        [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                        attributes:attributes
                           context:nil]
            .size;
#endif

    return ceil(textSize.width);
}

- (CGSize)nx_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
        textSize =
            [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                            attributes:attributes
                               context:nil]
                .size;
    }
    else
    {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
    textSize =
        [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                        attributes:attributes
                           context:nil]
            .size;
#endif

    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

- (CGFloat)nx_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
        textSize =
            [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                            attributes:attributes
                               context:nil]
                .size;
    }
    else
    {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : textFont, NSParagraphStyleAttributeName : paragraph};
    textSize =
        [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                        attributes:attributes
                           context:nil]
            .size;
#endif

    return ceil(textSize.height);
}

#pragma mark -
- (BOOL)nx_isValidateUrl
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http|https)://"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];

    return result ? YES : NO;
}

- (NSString *)nx_URLEncoded
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
}

- (NSString *)nx_md5HexDigest
{
    const char *original_str = [self UTF8String];

    unsigned char result[CC_MD5_BLOCK_BYTES];

    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);

    NSMutableString *hash = [NSMutableString string];

    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }

    return [hash lowercaseString];
}

- (NSString *)nx_sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (int)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

- (NSString *)nx_base64Encoded
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)nx_base64Decoded
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//判断是否是中文
+ (BOOL)isChinese:(NSString *)str index:(int)index
{
    int a = [str characterAtIndex:index];

    if ((a > 0x4e00 && a < 0x9fff) || a == 0x3000 || a == 0x0020)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)str
{
    BOOL containSingleChar = NO;
    NSString *r0 = @".*[0-9a-zA-Z]+.*";
    NSPredicate *p0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", r0];
    containSingleChar = [p0 evaluateWithObject:str];
    if (containSingleChar)
    {
        return NO;
    }

    BOOL isChinese = NO;
    NSString *regex = @"[\u4e00-\u9fa5\u3000-\u301e\ufe10-\ufe19\ufe30-"
                      @"\ufe44\ufe50-\ufe6b\uff01-\uffee\x0020]+";
    //    NSString *regex =
    //    @"[\u4e00-\u9fa5\u3002\uff1f\uff01\uff0c\u3001\uff1b\uff1a\u300c\u300d\u300e\u300f\u2018\u2019\u201c\u201d\uff08\uff09\u3014\u33015\u3010\u3011\u2014\u2026\u2013\uff0e\u300a\u300b\u3008\u3009]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isChinese = [pred evaluateWithObject:str];
    return isChinese;
}

+ (BOOL)strContainsEmoji:(NSString *)str
{
    __block BOOL returnValue = NO;

    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                            options:NSStringEnumerationByComposedCharacterSequences
                         usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                             const unichar hs = [substring characterAtIndex:0];
                             if (0xd800 <= hs && hs <= 0xdbff)
                             {
                                 if (substring.length > 1)
                                 {
                                     const unichar ls = [substring characterAtIndex:1];
                                     const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                     if (0x1d000 <= uc && uc <= 0x1f77f)
                                     {
                                         returnValue = YES;
                                     }
                                 }
                             }
                             else if (substring.length > 1)
                             {
                                 const unichar ls = [substring characterAtIndex:1];
                                 if (ls == 0x20e3)
                                 {
                                     returnValue = YES;
                                 }
                             }
                             else
                             {
                                 if (0x2100 <= hs && hs <= 0x27ff)
                                 {
                                     returnValue = YES;
                                 }
                                 else if (0x2B05 <= hs && hs <= 0x2b07)
                                 {
                                     returnValue = YES;
                                 }
                                 else if (0x2934 <= hs && hs <= 0x2935)
                                 {
                                     returnValue = YES;
                                 }
                                 else if (0x3297 <= hs && hs <= 0x3299)
                                 {
                                     returnValue = YES;
                                 }
                                 else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 ||
                                          hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                                 {
                                     returnValue = YES;
                                 }
                             }
                         }];

    return returnValue;
}
@end
