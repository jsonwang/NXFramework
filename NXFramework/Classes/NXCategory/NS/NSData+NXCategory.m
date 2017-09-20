//
//  NSData+Crypto.m
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSData+NXCategory.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <zlib.h>

@implementation NSData (NXCategory)

- (BOOL)nx_isNotEmpty
{
    return (![(NSNull *)self isEqual:[NSNull null]] && [self isKindOfClass:[NSData class]] && self.length > 0);
}

- (NSData *)nx_encryptedDataUsingSHA1WithKey:(NSData *)key
{
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [self bytes], [self length], cHMAC);

    return [NSData dataWithBytes:&cHMAC length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)nx_dataWithMD5Hash
{
    const char *cStr = [self bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)[self length], digest);

    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)nx_contentType
{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([self length] < 12)
            {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)]
                                                         encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"])
            {
                return @"image/webp";
            }
            return nil;
    }
    return nil;
}

- (BOOL)nx_hasPrefixBytes:(const void *)prefix length:(NSUInteger)length
{
    if (!prefix || !length || self.length < length)
    {
        return NO;
    }
    return (memcmp([self bytes], prefix, length) == 0);
}

- (BOOL)nx_hasSuffixBytes:(const void *)suffix length:(NSUInteger)length
{
    if (!suffix || !length || self.length < length)
    {
        return NO;
    }
    return (memcmp(((const char *)[self bytes] + (self.length - length)), suffix, length) == 0);
}

#pragma mark - GZIP

#define NXFW_CHUNK_SIZE 16384

- (NSData *)gzippedDataWithCompressionLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;

        int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION : (int)roundf(level * 9);
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:NXFW_CHUNK_SIZE];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += NXFW_CHUNK_SIZE;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
}

- (NSData *)gzippedData { return [self gzippedDataWithCompressionLevel:-1.0f]; }
- (NSData *)gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;

        NSMutableData *data = [NSMutableData dataWithLength:[self length] * 1.5];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] * 0.5;
                }
                stream.next_out = [data mutableBytes] + stream.total_out;
                stream.avail_out = (uint)([data length] - stream.total_out);
                status = inflate(&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}

@end
