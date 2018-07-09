//
//  ImagePickerViewController.m
//  testDemo
//
//  Created by maple on 16/8/23.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "NXPhotoPickerController.h"
#import "NXPhotoCollectionViewCell.h"
#import "VPImageCropperViewController.h"
#import "UIImage+scale.h"
#import "NXGroupModel.h"
#import "NXAssetModel.h"
#import "NXPhotoService.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import "NXPhotoConfig.h"
#import "NX3DTouchPrevViewController.h"
      ///cell间距
#define kMargin 5
      ///一行显示几个cell
#define kCount 3
      ///缩放比率
#define kScaleRatio 3.0

@interface NXPhotoPickerController () <UICollectionViewDelegate, UICollectionViewDataSource, VPImageCropperDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIViewControllerPreviewingDelegate>
      ///图片资源数组
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation NXPhotoPickerController

- (void)setAssetModelArray:(NSArray *)assetModelArray {
      _assetModelArray = assetModelArray;
      [self.collectionView reloadData];
}

static NSString *ID = @"cell";
- (void)viewDidLoad {
      [super viewDidLoad];
      self.collectionView.backgroundColor = [UIColor whiteColor];
      [self setupNavgationBar];
            //显示相机胶卷相册内容
      if(self.isShowCameraRoll) {
            [self showCameraRollContent];
      }
}

      ///显示相机胶卷相册内容
- (void)showCameraRollContent {
      [SVProgressHUD showWithStatus:@"加载中..."];
    [[NXPhotoService shareInstanced] fetchCameraRollAlbumListWithType:NXPhotoLibarayAssertTypePhotos completion:^(NSArray<NXGroupModel *> * _Nullable array) {
        self.assetModelArray = [array firstObject].asstArray;
        [SVProgressHUD dismiss];
        [self.collectionView reloadData];
        
    }];

}

- (void)setupNavgationBar {

            //设置标题的字号
      NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:20.],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName,nil];
      self.navigationController.navigationBar.titleTextAttributes = size;

            //返回btn
      UIImage *naviImage = [UIImage imageNamed:@"icon_dropdown_normal.png"];
      UIButton *naviBtn =
      [[UIButton alloc] initWithFrame:CGRectMake(0, 0, naviImage.size.width, naviImage.size.height)];
      naviBtn.exclusiveTouch = YES;
      [naviBtn setImage:naviImage forState:UIControlStateNormal];
      naviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [naviBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
      UIBarButtonItem *naviBtnItem = [[UIBarButtonItem alloc] initWithCustomView:naviBtn];
      self.navigationItem.leftBarButtonItem = naviBtnItem;
      self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

      //取消
      UIImage *backImage = [UIImage imageNamed:@"icon_jiahao"];
      UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
      sendBtn.exclusiveTouch = YES;
      [sendBtn setTitle:@"取消" forState:UIControlStateNormal];
      sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
      [sendBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
      sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];


}
- (void)backToPrevious
{
      //返回到上一层堆栈 todo 可以用传自定义事件行为
      [self.navigationController popViewControllerAnimated:YES];

}
- (void)cancle {

      if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSeletedImage:)])
          {
            [self.delegate cancelSeletedImage:self];
          }
      [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  显示图片编辑界面
 */
- (void)showEditImageController:(UIImage *)image {
    CGSize clipSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width);
    if(!CGSizeEqualToSize([NXPhotoConfig shareInstanced].clipSize, CGSizeZero))
    {
       clipSize = [NXPhotoConfig shareInstanced].clipSize;
       double scale = self.view.bounds.size.width / clipSize.width;
       clipSize.width = self.view.bounds.size.width;
       clipSize.height = clipSize.height * scale;
    }
      CGFloat y = (self.view.bounds.size.height - clipSize.height) / 2.0;
      CGFloat x = (self.view.bounds.size.width - clipSize.width)/2.0f;
      VPImageCropperViewController *imageCropper = [[VPImageCropperViewController alloc]
                                                    initWithImage:image
                                                    cropFrame:CGRectMake(0, y,clipSize.width,clipSize.height) limitScaleRatio:kScaleRatio];
      imageCropper.delegate = self;
      [self.navigationController pushViewController:imageCropper animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//      return self.assetModelArray.count + 1;
      return self.assetModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      NXPhotoCollectionViewCell *cell = (NXPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
      NXAssetModel *asset = self.assetModelArray[indexPath.row];
      cell.asset = asset;
    
    if ([[NXPhotoConfig shareInstanced] open3DTouchPrev])
    {
        //注册3D Touch
        /**
         从iOS9开始，我们可以通过这个类来判断运行程序对应的设备是否支持3D Touch功能。
         UIForceTouchCapabilityUnknown = 0,     //未知
         UIForceTouchCapabilityUnavailable = 1, //不可用
         UIForceTouchCapabilityAvailable = 2    //可用
         */
        if ([self respondsToSelector:@selector(traitCollection)]) {
            
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                if (@available(iOS 9.0, *)) {
                    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                        [self registerForPreviewingWithDelegate:self sourceView:cell];
                    }
                }
            }
        }
        
    }
      return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //处理点击相机的事件
    __weak typeof(self) weakSelf = self;
    NXAssetModel * assetModel = self.assetModelArray[indexPath.row];
    
    [[NXPhotoService shareInstanced] requestOriginalImageForAsset:assetModel success:^(UIImage * _Nullable image) {
        [SVProgressHUD dismiss];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf showEditImageController:image];
        }
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
    } progressBlock:^(double progress) {
        if(![SVProgressHUD isVisible])
        {
            [SVProgressHUD showWithStatus:@"加载中..."];
        }
    }];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
      if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinished:)]) {
            NSLog(@"%@", editedImage);
            [self.delegate imagePickerController:self didFinished:editedImage];
      }
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
      [cropperViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
      UIImage *image = [info[@"UIImagePickerControllerOriginalImage"] scaleImage];
      [picker dismissViewControllerAnimated:YES completion:^{
            [self showEditImageController:image];
      }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
      [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)assetArray {
      if (_assetArray == nil) {
            _assetArray = [NSMutableArray array];
      }
      return _assetArray;
}

- (UICollectionView *)collectionView {
      if (_collectionView == nil) {
                  //设置布局属性
            UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
            CGFloat wid = ([UIScreen mainScreen].bounds.size.width - (kCount - 1) * kMargin) / kCount;
            flow.itemSize = CGSizeMake(wid, wid);
            flow.minimumLineSpacing = kMargin;
            flow.minimumInteritemSpacing = kMargin;

                  //添加collectionView
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flow];
            self.collectionView = collectionView;
            self.collectionView.backgroundColor = [UIColor whiteColor];
                  //设置代理
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
                  //注册
            [self.collectionView registerClass:[NXPhotoCollectionViewCell class] forCellWithReuseIdentifier:ID];
            [self.view addSubview:collectionView];
      }
      return _collectionView;
}

#pragma mark - UIViewControllerPreviewingDelegate
// If you return nil, a preview presentation will not be performed
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    UIViewController * controller;
    if (@available(iOS 9.0, *))
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(NXPhotoCollectionViewCell *)[previewingContext sourceView]];
        
        NXAssetModel * assetModel = self.assetModelArray[indexPath.row];
        NX3DTouchPrevViewController * preViewController = [[NX3DTouchPrevViewController alloc] init];
        preViewController.assetModel = assetModel;
        controller = preViewController;
        __weak typeof(self) weakSelf = self;
        [preViewController setSeletedImageBlock:^(UIImage *image)
        {
            [weakSelf showEditImageController:image];
        }];
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        previewingContext.sourceRect = rect;
    }
    return controller;
    
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}
@end
