//
//  NXPhotoOrCamera.h
//
//  Created by 王成 on 14-6-22.
//
//

/**
 *  本类 功能 从相册或 相机里整出来一个相片
 *  eg. new the classes you can call all or sharedInstancd new object.
 */

/* 注意在使用本类的时候, 类 里要 调用 didReceiveMemoryWarning。
 - (void)didReceiveMemoryWarning
 {
 NSLog(@"didReceiveMemoryWarning");
 [super didReceiveMemoryWarning];

 [[NSURLCache sharedURLCache] removeAllCachedResponses];

 }

 */

#import <Foundation/Foundation.h>

@class NXPhotoOrCamera;
@protocol NXPhotoOrCameraDelegate<NSObject>

- (void)imagePickerControllerWillAppear:(UIImagePickerController *)pickerController;
// 选择图片完成
- (void)selectFinishedWithImage:(UIImage *)image photoOrCamera:(NXPhotoOrCamera *)photoOrCamera;

- (void)cancelSeletedPickerImageController:(UIImagePickerController *)controller;

@end

@interface NXPhotoOrCamera : NSObject<UIActionSheetDelegate>

@property(nonatomic, assign) BOOL allowEdit;

@property(nonatomic, assign) id<NXPhotoOrCameraDelegate> delegate;

+ (NXPhotoOrCamera *)sharedInstance;


/**
 显示菜单

 @param controller 显示 ActionSheet 的控制器
 */
- (void)showActionSheetWithController:(UIViewController *)controller;

/**
  显示imagepicker 如有需要 请求相册权限

 @param hasAnimation 是否需要动画
 @param type 需要的资源类型
 */
- (void)showImagePickerWithAnimation:(BOOL)hasAnimation sourceType:(UIImagePickerControllerSourceType)type;

@end
