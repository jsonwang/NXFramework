//
//  NXPhotoViewController.m
//  NXFramework_Example
//
//  Created by liuming on 2018/7/3.
//  Copyright © 2018年 wangcheng. All rights reserved.
//

#import "NXPhotoViewController.h"
#import "NXImagePickerController.h"
#import <Photos/Photos.h>
@interface NXPhotoViewController ()<ImagePickerControllerDelgate>

@end

@implementation NXPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"open album" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 100, 320, 40);
    [btn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)openAlbum
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NXImagePickerController *alubmPicker = [[NXImagePickerController alloc] initWithDelegate:self];
            [self presentViewController:alubmPicker animated:YES completion:nil];
        }else {
            
        }
    }];
}
    
    /// 返回裁剪后的图片
- (void)imagePickerController:(NXPhotoPickerController *)imagePickerController
                  didFinished:(UIImage *)editedImage{
    
}
    
- (void)cancelSeletedImage:(NXPhotoPickerController *)imagePickerController
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
