//
//  AlbumPickerController.m
//  testDemo
//
//  Created by maple on 16/8/24.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "NXAlbumPickerController.h"
#import "NXPhotoPickerController.h"
#import "AssetModel.h"
#import "AlbumModel.h"
#import "NXImagePickerController.h"
#import "ImageManager.h"
#import "NXAlbumPickerCell.h"
#import <Photos/Photos.h>

@interface NXAlbumPickerController ()
///相册数组
@property (nonatomic, strong) NSArray *alubmArray;

@end

@implementation NXAlbumPickerController

static NSString *ID = @"album";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavgationBar];
    //注册cell
    [self.tableView registerClass:[NXAlbumPickerCell class] forCellReuseIdentifier:ID];
    self.tableView.rowHeight = 70;

    self.alubmArray = [ImageManager sharedManager].albumModelArray;
    self.title = @"相册";
}

- (void)setupNavgationBar {
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

- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
      if(self.imagePickerDelegate && [self.imagePickerDelegate respondsToSelector:@selector(cancelSeletedImage:)]){

            [self.imagePickerDelegate cancelSeletedImage:nil];
      }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alubmArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NXAlbumPickerCell *cell = (NXAlbumPickerCell *)[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    AlbumModel *model = self.alubmArray[indexPath.row];
    cell.albumModel = model;
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumModel *model = self.alubmArray[indexPath.row];
    NXPhotoPickerController *photoPicker = [[NXPhotoPickerController alloc] init];
    NXImagePickerController *pickerNav = (NXImagePickerController *)self.navigationController;
    photoPicker.delegate = pickerNav.imagePickerDelegate;
    photoPicker.assetModelArray = model.models;
    photoPicker.title = model.name;
    [self.navigationController pushViewController:photoPicker animated:YES];
}





@end
