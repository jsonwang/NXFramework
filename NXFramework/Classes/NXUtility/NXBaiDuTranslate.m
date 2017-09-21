//
//  NXBaiDuTranslate.m
//  NXlib
//
//  Created by AK on 15/12/20.
//  Copyright © 2015年 AK. All rights reserved.
//

static const NSString *BAIDUAPPID = @"20151214000007777";

static const NSString *BAIDUAPPSIGN = @"_D70LZwdTU8LvsMOqaFW";

#import "NXBaiDuTranslate.h"
#import "NSString+NXCategory.h"

@interface NXBaiDuTranslate ()<NSURLConnectionDataDelegate>
{
    NSMutableData *resposData;
}

@end

@implementation NXBaiDuTranslate

- (id)init
{
    if (self = [super init])
    {
    }

    return self;
}

// e.g.
// http://api.fanyi.baidu.com/api/trans/vip/translate?q=apple&from=en&to=zh&appid=2015063000000001&salt=1435660288&sign=f89f9594663708c1605f3d736d01d2d4
- (void)translateWithQuery:(NSString *)translateStr
                   success:(void (^)(NXBaiDuTranslate *operation, id responseObject))success
                   failure:(void (^)(NXBaiDuTranslate *operation, NSError *error))failure
{
    if ([translateStr isKindOfClass:[NSNull class]] || translateStr.length == 0)
    {
        NSLog(@"your translate input date error!!!");

        if (self.translateCompleteFailure)
        {
            //传出参数
            self.translateCompleteFailure(self, [[NSError alloc] initWithDomain:@"输入参数错误" code:0 userInfo:nil]);
        }
        return;
    }
    else
    {
        NSLog(@"you will translate str is :%@", translateStr);
    }

    self.translateCompleteSuccess = success;

    self.translateCompleteFailure = failure;

    int salt = arc4random();

    // 1,appid+q+salt+密钥 的顺序拼接得到字符串
    // 2,对字符串做md5，得到32位小写的sign。
    NSString *sign = [[NSString
        stringWithString:[[NSString stringWithFormat:@"%@%@%d%@", BAIDUAPPID, translateStr, salt, BAIDUAPPSIGN]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] nx_md5HexDigest];

    NSString *urlString = [NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/"
                                                     @"translate?q=%@&from=zh&to=en&appid=%@&salt="
                                                     @"%d&sign=%@",
                                                     translateStr, BAIDUAPPID, salt, sign];

    NSLog(@"发请求前的URL %@", urlString);

    [NSURLConnection
        connectionWithRequest:[NSURLRequest
                                  requestWithURL:[NSURL
                                                     URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:
                                                                                  NSUTF8StringEncoding]]]
                     delegate:self];
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"HTTP response...size of nsdata is %d", (int)[data length]);
    [resposData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    resposData = [[NSMutableData alloc] init];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSDictionary *jsonDIC =
        [NSJSONSerialization JSONObjectWithData:resposData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"编译返回结果 %@", jsonDIC);

    if (error)
    {
        self.translateCompleteFailure(self, nil);

        return;
    }

    NSArray *transResult;
    if ([jsonDIC objectForKey:@"trans_result"])
    {
        transResult = [jsonDIC objectForKey:@"trans_result"];

        if (transResult.count > 0)
        {
            NSString *dst = [[transResult objectAtIndex:0] objectForKey:@"dst"];

            if (![dst isKindOfClass:[NSNull class]] && dst.length > 0)
            {
                if (self.translateCompleteSuccess)
                {
                    //传出参数 翻译后的字符串
                    self.translateCompleteSuccess(self, dst);
                }
            }
        }
    }
    else
    {
        NSError *error;

        if ([jsonDIC objectForKey:@"error_code"] && [jsonDIC objectForKey:@"error_msg"])
        {
            error = [[NSError alloc] initWithDomain:[jsonDIC objectForKey:@"error_msg"]
                                               code:((NSString *)[jsonDIC objectForKey:@"error_code"]).intValue
                                           userInfo:nil];
        }

        self.translateCompleteFailure(self, error);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"HTTP connection error out %@", error.userInfo);
    if (self.translateCompleteFailure)
    {
        self.translateCompleteFailure(self, error);
    }
}

@end
