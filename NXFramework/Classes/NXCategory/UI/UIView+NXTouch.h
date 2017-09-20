//
//  UIView+NXTouch.h
//  NXSpringViewDemo
//
//  Created by 陈方方 on 2017/3/23.
//  Copyright © 2017年 陈方方. All rights reserved.
//
/*
 UIView 及其子类可以调用防止多次点击 (目前UIControl的子类不行)
 
如:
 UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTouch:)];
 [view addGestureRecognizer:tap];
 view.nx_acceptEventInterval=2;

 cell.nx_acceptEventInterval = 3;

 
 */

#import <UIKit/UIKit.h>

@interface UIView (NXTouch)


/**
 *  设置重复点击加间隔。
 */
@property(nonatomic, assign) NSTimeInterval nx_acceptEventInterval;

/**
 *  忽略本次点击。
 */
@property(nonatomic) BOOL ignoreEvent;


@end
