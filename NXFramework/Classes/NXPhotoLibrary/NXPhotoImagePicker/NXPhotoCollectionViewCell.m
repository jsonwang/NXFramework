//
//  NXPhotoCollectionViewCell.m
//  testDemo
//
//  Created by maple on 16/8/23.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "NXPhotoCollectionViewCell.h"
#import "NXAssetModel.h"
#import "NXPhotoService.h"

#import "NXPhotoConfig.h"
@interface NXPhotoCollectionViewCell()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation NXPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setAsset:(NXAssetModel *)asset {
    _asset = asset;
    __weak typeof(self) weakSelf = self;
    [[NXPhotoService shareInstanced] requestImageForAsset:_asset size:CGSizeMake(240, 240) success:^(UIImage * _Nullable image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.imageView.image  = image;
        }
    } failure:^(NSError * _Nullable error){
        NSLog(@"error  get thumbImage error");
    } progressBlock:nil];
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setupUI {
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置imageView的填充模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

@end
