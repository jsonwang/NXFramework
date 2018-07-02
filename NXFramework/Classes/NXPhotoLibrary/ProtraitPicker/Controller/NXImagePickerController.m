//
//  NXImagePickerController.m
//  testDemo
//
//  Created by maple on 16/8/24.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "NXImagePickerController.h"
#import "NXPhotoPickerController.h"
#import "NXAlbumPickerController.h"
#import "ImageManager.h"
#import "AlbumModel.h"
#import <Photos/Photos.h>


@interface NXImagePickerController ()

@end

@implementation NXImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (instancetype)initWithDelegate:(id<ImagePickerControllerDelgate>)delegate; {
    NXAlbumPickerController *albumPicker = [[NXAlbumPickerController alloc] init];
      albumPicker.imagePickerDelegate = delegate;
    self = [super initWithRootViewController:albumPicker];
    _imagePickerDelegate = delegate;
    [self pushPhotoPicker];
    return self;
}

- (void)pushPhotoPicker {
    NXPhotoPickerController *photoPicker = [[NXPhotoPickerController alloc] init];
    photoPicker.delegate = self.imagePickerDelegate;
    //默认显示相机胶卷
    photoPicker.showCameraRoll = YES;
    photoPicker.title = @"相机胶卷";
    [self pushViewController:photoPicker animated:YES];
}





@end
