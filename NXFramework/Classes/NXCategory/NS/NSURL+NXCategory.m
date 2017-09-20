//
//  NSURL+Unshorten.m
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import "NSURL+NXCategory.h"

@implementation NSURL (NXCategory)

- (void)nx_unshortenWithCompletion:(NSURLUnshortenCompletionHandler)completion
{
    static NSCache *unshortenCache = nil;
    static dispatch_queue_t shortenQueue = NULL;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unshortenCache = [[NSCache alloc] init];
        shortenQueue = dispatch_queue_create("DTUnshortenQueue", 0);
    });

    NSURL *shortURL = self;

    // assume HTTP if scheme is missing
    if (![self scheme])
    {
        NSString *str = [@"http://" stringByAppendingString:[self absoluteString]];
        shortURL = [NSURL URLWithString:str];
    }

    dispatch_async(shortenQueue, ^{
        // look into cache first
        NSURL *longURL = [unshortenCache objectForKey:shortURL];

        // nothing cached, load it
        if (!longURL)
        {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:shortURL];
            request.HTTPMethod = @"HEAD";

            NSError *error = nil;
            NSHTTPURLResponse *response = nil;

            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

            longURL = [response URL];

            // cache result
            if (longURL)
            {
                [unshortenCache setObject:longURL forKey:shortURL];
            }
        }

        if (completion)
        {
            completion(longURL);
        }
    });
}

- (BOOL)nx_isEqualToURL:(NSURL *)URL
{
    // scheme must be same
    if (![[self scheme] isEqualToString:[URL scheme]])
    {
        return NO;
    }

    // host must be same
    if (![[self host] isEqualToString:[URL host]])
    {
        return NO;
    }

    // path must be same
    if (![[self path] isEqualToString:[URL path]])
    {
        return NO;
    }

    return YES;
}

@end

@implementation NSURL (NXAppLinks)

+ (NSURL *)nx_appStoreURLforApplicationIdentifier:(NSString *)identifier
{
    NSString *link = [NSString stringWithFormat:@"%@%@", NXAppStoreURL, identifier];

    return [NSURL URLWithString:link];
}

+ (NSURL *)nx_appStoreReviewURLForApplicationIdentifier:(NSString *)identifier
{
    NSString *link = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/"
                                                @"viewContentsUserReviews?type=Purple+Software&id=%@",
                                                identifier];
    NSLog(@"LINK %@", link);
    return [NSURL URLWithString:link];
}

@end
