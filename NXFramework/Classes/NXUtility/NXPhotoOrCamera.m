//
//  NXPhotoOrCamera
//
//
//  Created by 王成 on 14-6-22.
//
//

#import "NXPhotoOrCamera.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "NXActionSheet.h"
#import "ImagePickerController.h"
@interface NXPhotoOrCamera ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,ImagePickerControllerDelgate>
{
    UIViewController *showController;
}

@end

@implementation NXPhotoOrCamera
@synthesize allowEdit;
static NXPhotoOrCamera *selectPhotoOrCamera = nil;

+ (NXPhotoOrCamera *)sharedInstance
{
    if (selectPhotoOrCamera == nil)
    {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{

            selectPhotoOrCamera = [[super allocWithZone:nil] init];

            selectPhotoOrCamera.allowEdit = YES;

        });
    }
    return selectPhotoOrCamera;
}

+ (id)allocWithZone:(NSZone *)zone { return [self sharedInstance]; }
- (id)copyWithZone:(NSZone *)zone { return self; }
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

#pragma mark - class methods
- (void)showActionSheetWithController:(UIViewController *)controller
{
    showController = controller;

    NXActionSheet *actionSheet;
        actionSheet = [[NXActionSheet alloc] initWithTitle:@"选择图片"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照", @"从相册中选取", nil];
 
    [actionSheet showInView:controller.view.window];
    
    [actionSheet setClickedHandler:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
       
        NSLog(@"buttonIndex %ld",(long)buttonIndex);
      
        if (buttonIndex == 0 )
        {
            [self showImagePickerWithAnimation:YES
                                    sourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1)
        {
//            [self showImagePickerWithAnimation:YES
//                                sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
          [self showCustomImagePicker];

        }
        else if (buttonIndex == 2)
            {
              if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSeletedPickerImageController:)])
                  {
                    [self.delegate cancelSeletedPickerImageController:nil];
                  }
        }
       
    
    }];
}

#pragma marm -- 打开
- (void)showCustomImagePicker
{
      [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                  ImagePickerController *alubmPicker = [[ImagePickerController alloc] initWithDelegate:self];
                  [showController presentViewController:alubmPicker animated:YES completion:nil];
                  if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerWillAppear:)])
                      {
                        [self.delegate imagePickerControllerWillAppear:alubmPicker];
                      }
            }else {
                  [self showSetting];
            }
      }];
}

- (void)showSetting {
      UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在系统设置中打开“允许访问图片”，否则将无法获取相机的图片" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
      UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
      }];
      [alertVC addAction:cancle];
      [alertVC addAction:confirm];
      [showController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - class methods
// base on the image source type,set the picker controller
- (void)showImagePickerWithAnimation:(BOOL)hasAnimation sourceType:(UIImagePickerControllerSourceType)type
{
    // 第一次访问相册时
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
    {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (*stop)
                {
                    //点击“好”回调方法:
                    NSLog(@"好");
                    return;
                }
                *stop = TRUE;
            }
            failureBlock:^(NSError *error) {
                //点击“不允许”回调方法:
                NSLog(@"不允许");

                [showController dismissViewControllerAnimated:YES completion:nil];
            }];
    }

    // method 2: system picker

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    // 此前允许访问相册，再次访问时；或首次访问
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized ||
        [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
    {
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = type;

        imagePickerController.allowsEditing = allowEdit;

        imagePickerController.delegate = self;

        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
    }

    // 设置TopBar的StatusBar背景
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0)
    {
        //        UIImage *backgroundImage = [UIImage
        //        imageNamed:@"bg_navigationbar_ios7_h.png"];
        //                    [imagePickerController.navigationBar
        //                    setBackgroundImage:backgroundImage
        //                    forBarMetrics:UIBarMetricsDefault];
        imagePickerController.navigationBar.translucent = NO;
        imagePickerController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        imagePickerController.navigationBar.tintColor = [UIColor whiteColor];

        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else if (version >= 5.0)
    {
        //        UIImage *backgroundImage = [UIImage
        //        imageNamed:@"btn_navigationbar_h.png"];
        //        [imagePickerController.navigationBar
        //        setBackgroundImage:backgroundImage
        //        forBarMetrics:UIBarMetricsDefault];
        //                    [imagePickerController.navigationBar
        //                    setBackgroundColor:[UIColor blackColor]];
        //        imagePickerController.navigationBar.barStyle =
        //        UIBarStyleBlackOpaque;
    }
      if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerWillAppear:)])
          {
            [self.delegate imagePickerControllerWillAppear:imagePickerController];
          }
    [showController presentViewController:imagePickerController animated:hasAnimation completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        //隐藏tab
        //        [showController.rootDelegate.tabBar setTabBarHidden:YES
        //        animated:NO];

        //        imagePickerController.navigationBar.translucent = NO;
        navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        navigationController.navigationBar.tintColor = [UIColor whiteColor];

        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


#pragma mark - UIImagePickerControllerDelegate set photo
//处理相机、相册得到的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @autoreleasepool
    {
        UIImage *image = nil;

        //是不是读编辑后的图片
        if (self.allowEdit)
        {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        [picker dismissViewControllerAnimated:YES
                                   completion:^{

                                   }];

        //        [showController.rootDelegate.tabBar setTabBarHidden:NO
        //        animated:NO];

        if (self.delegate && [self.delegate respondsToSelector:@selector(selectFinishedWithImage:photoOrCamera:)])
        {
            [self.delegate selectFinishedWithImage:image photoOrCamera:self];
        }

        image = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [showController.rootDelegate.tabBar setTabBarHidden:NO animated:NO];
    [picker dismissViewControllerAnimated:YES
                               completion:^{

                               }];

      if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSeletedPickerImageController:)])
          {
            [self.delegate cancelSeletedPickerImageController:picker];
          }
}
#pragma mark custom ImagePicker Delegate
- (void)imagePickerController:(NXPhotoPickerController *)imagePickerController
                  didFinished:(UIImage *)editedImage
{
      [imagePickerController dismissViewControllerAnimated:YES completion:nil];
      if (self.delegate && [self.delegate respondsToSelector:@selector(selectFinishedWithImage:photoOrCamera:)])
          {
            [self.delegate selectFinishedWithImage:editedImage photoOrCamera:self];
          }
}
- (void)cancelSeletedImage:(NXPhotoPickerController *)imagePickerController
{
      if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSeletedPickerImageController:)])
          {
            [self.delegate cancelSeletedPickerImageController:nil];
          }
}
@end
