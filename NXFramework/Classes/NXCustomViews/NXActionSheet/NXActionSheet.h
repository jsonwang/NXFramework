//
//  NXActionSheet.h
//  NXlib
//
//  Created by AK on 14/12/8.
//  Copyright (c) 2014年 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NXActionSheetClickedHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void (^NXActionSheetCancelHandler)(UIActionSheet *actionSheet);
typedef void (^NXActionSheetWillPresentHandler)(UIActionSheet *actionSheet);
typedef void (^NXActionSheetDidPresentHandler)(UIActionSheet *actionSheet);
typedef void (^NXActionSheetWillDismissHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);
typedef void (^NXActionSheetDidDismissHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface NXActionSheet : UIActionSheet
/*
 * 点击 "完成" 回调
 *
 */
- (void)setClickedHandler:(NXActionSheetClickedHandler)clickedHandler;

/*
 * 点击 "取消" 回调
 *
 */
- (void)setCancelHandler:(NXActionSheetCancelHandler)cancelHandler;

/*
 * 即将显示回调
 *
 */
- (void)setWillPresentHandler:(NXActionSheetWillPresentHandler)willPresentHandler;

/*
 * 显示完成回调
 *
 */
- (void)setDidPresentHandler:(NXActionSheetDidPresentHandler)didPresentHandler;

/*
 * 即将消失回调
 *
 */
- (void)setWillDismissHandler:(NXActionSheetWillDismissHandler)willDismissHandler;

/*
 * 消失完成回调
 *
 */
- (void)setDidDismissHandler:(NXActionSheetDidDismissHandler)didDismissHandler;

@end
