//
//  NXToolbar.h
//  NXlib
//
//  Created by AK on 9/23/14.
//  Copyright (c) 2014 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NXToolbarActionStyle) {
    NXToolbarActionStyleNone,
    NXToolbarActionStyleDoneAndCancel,
};

@protocol NXToolbarActionDelegate;

@interface NXToolbar : UIToolbar

@property(nonatomic, weak) id<NXToolbarActionDelegate> actionDelegate;

@property(nonatomic, assign) NXToolbarActionStyle actionStyle;

- (instancetype)initWithFrame:(CGRect)frame actionStyle:(NXToolbarActionStyle)actionStyle;

@end

@protocol NXToolbarActionDelegate<NSObject>

// 点击完成按钮
- (void)toolbarDidDone:(NXToolbar *)toolbar;
// 点击取消按钮
- (void)toolbarDidCancel:(NXToolbar *)toolbar;

@end
