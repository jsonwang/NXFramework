//
//  NSURL+Unshorten.h
//  NXLib
//
//  Created by AK on 14-3-28.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NXSystemInfo.h"

/** Method for getting the full length URL for a shortened one.

 For example:

 NSURL *url = [NSURL URLWithString:@"buff.ly/L4uGoza"];

 [url unshortenWithCompletion:^(NSURL *url) {
 NSLog(@"Unshortened: %@", url);
 }];

 */

typedef void (^NSURLUnshortenCompletionHandler)(NSURL *);

@interface NSURL (NXCategory)

/**
 Unshortens the receiver and returns the long URL via the completion handler.

 Results are cached and therefore a subsequent call for the same receiver will
 return instantly if the result is still
 present in the cache.
 @param completion The completion handler
 */
- (void)nx_unshortenWithCompletion:(NSURLUnshortenCompletionHandler)completion;

/**
 Compares the receiver with another URL
 @param URL another URL
 @returns `YES` if the receiver is equivalent with the passed URL
 */
- (BOOL)nx_isEqualToURL:(NSURL *)URL;

@end

/** A collection of category extensions for `NSURL` that provide direct access
 to built-in app capabilities.

 For example: Open the app store on the page for the app

 NSURL *appURL = [NSURL appStoreURLforApplicationIdentifier:@"463623298"];
 [[UIApplication sharedApplication] openURL:appURL];
 */

@interface NSURL (NXAppLinks)

/**-------------------------------------------------------------------------------------
 @name Mobile App Store Pages
 ---------------------------------------------------------------------------------------
 */

/** Returns the URL to open the mobile app store on the app's page.

 URL construction as described in
 [QA1629](https://developer.apple.com/library/ios/#qa/qa2008/qa1629.html). Test
 and
 found to be opening the app store app directly even without the itms: or
 itms-apps: scheme. This kind of URL can also
 be used to forward a link to the app to non-iOS devices.

 @param identifier The application identifier that gets assigned to a new app
 when you add it to iTunes Connect.
 @return Returns the URL to the direct app store link
 */
+ (NSURL *)nx_appStoreURLforApplicationIdentifier:(NSString *)identifier;

/** Returns the URL to open the mobile app store on the app's review page.

 The reviews page is a sub-page of the normal app landing page you get with
 appStoreURLforApplicationIdentifier:

 @param identifier The application identifier that gets assigned to a new app
 when you add it to iTunes Connect.
 @return Returns the URL to the direct app store link
 */
+ (NSURL *)nx_appStoreReviewURLForApplicationIdentifier:(NSString *)identifier;

@end
