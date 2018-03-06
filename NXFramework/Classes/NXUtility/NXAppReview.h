//
//  NXAppReview.h
//  NXlib
//
//  Created by AK on 14-5-22.
//  Copyright (c) 2014年 AK. All rights reserved.
//

/**
 *  功能 APP 评论
 *    XXXX TODO 不同IOS系统版本
 *
 */

#import <Foundation/Foundation.h>

@class NXAppReview;
@protocol appReviewDelegate<NSObject>

@optional

- (void)appReviewWillPresentModalView:(NXAppReview *)appirater animated:(BOOL)animated;
- (void)appReviewDidDismissModalView:(NXAppReview *)appirater animated:(BOOL)animated;

@end

@interface NXAppReview : NSObject
{
}
@property(nonatomic, weak) id<appReviewDelegate> delegate;

+ (NXAppReview *)sharedInstance;


/**
 跳转到appstore的评分界面
 
 @param APPID appid 在苹果后台可以取到
 */
- (void)rateAppWitchAppID:(NSString *)APPID;

@end

