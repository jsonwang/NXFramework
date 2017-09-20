//
//  NXLaunchVC.h
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    NXLaunchTypeAD,//广告
    NXLaunchTypeScrollGuide,//轮播图新手导引类型
    NXLaunchTypeGif,//gif图背景类型
    NXLaunchTypeRoll,//滚动图片类型
} NXLaunchType;

typedef enum {
    ImageLoadTypeDownload,//网络加载
    ImageLoadTypeLocalName,//本地
    ImageLoadTypeLocalPath,//本地路径
} NXImageLoadType;


@interface NXLaunchVC : UIViewController


/**
 隐藏lauchVC
 */
@property(copy) void (^hideLaunchView)(id extureInfo);



/**
 加载页面

 @param launchType launchType
 @param imageLoadType 图片加载方式
 @param imageArray 图片数组
 */
-(void)loadLauchViewWithLaunchType:(NXLaunchType)launchType
                     imageLoadType:(NXImageLoadType)imageLoadType
                        imageArray:(NSArray*)imageArray;

/**
 跳过按钮图片
 */
@property(nonatomic,copy)UIImage * skipImage;

/**
 跳过按钮title
 */
@property(nonatomic,copy)NSString * skipTitle;


#pragma mark - ad

/**
 图片未出现之时的占位图,可自行设置.
 */
@property(nonatomic,strong)NSString *placeholderImageName;


/**
 广告页的持续时间,默认为5秒钟
 */
@property(nonatomic,assign)NSInteger adTime;


/**
 广告的连接地址
 */
@property(nonatomic,strong)NSString *adURL;


/**
 广告页面标题
 */
@property(nonatomic,strong)NSString *titleString;

#pragma mark - guide


/**
 新手导引的页面标记
 */
@property(nonatomic,strong)UIPageControl *pageControl;



#pragma mark - gif

/**
 以动态图片为背景的frontView.
 */
@property(nonatomic,strong)UIView *frontGifView;


#pragma mark - roll

/**
 以滚动视图为背景的view
 */
@property(nonatomic,strong)UIView *frontRollView;

//进入app按钮图片
@property(nonatomic, copy) UIImage * enterImage;

@end
