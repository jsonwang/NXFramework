//
//  NXAlbumPickerCell.m
//  testDemo
//
//  Created by maple on 16/8/29.
//  Copyright © 2016年 maple. All rights reserved.
//

#import "NXAlbumPickerCell.h"
#import "NXGroupModel.h"
#import "NXAssetModel.h"
#import <Photos/Photos.h>
#import "NXPhotoService.h"
@interface NXAlbumPickerCell ()
@property (weak, nonatomic) UIImageView *posterImageView;
@property (weak, nonatomic) UILabel *titleLable;
@property (weak, nonatomic) UIImageView *arrowImageView;
@end

@implementation NXAlbumPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbumModel:(NXGroupModel *)albumModel {
    _albumModel = albumModel;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:albumModel.collection.localizedTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",albumModel.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLable.attributedText = nameString;
    NXAssetModel *assetModel = [albumModel.asstArray firstObject];
    __weak typeof(self) weakSelf = self;
    [[NXPhotoService shareInstanced] requestImageForAsset:assetModel size:CGSizeMake(240, 240) success:^(UIImage * _Nullable image)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(strongSelf)
        {
            strongSelf.posterImageView.image = image;
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@" NXAlbumPickerCell get thumb Image error = %@",[error userInfo]);
    } progressBlock:nil];
    
}
#pragma mark - 懒加载

- (UIImageView *)posterImageView {
    if (_posterImageView == nil) {
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        posterImageView.clipsToBounds = YES;
        posterImageView.frame = CGRectMake(0, 0, 70, 70);
        [self.contentView addSubview:posterImageView];
        _posterImageView = posterImageView;
    }
    return _posterImageView;
}

- (UILabel *)titleLable {
    if (_titleLable == nil) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont boldSystemFontOfSize:17];
        titleLable.frame = CGRectMake(80, 0, self.frame.size.width - 80 - 50, self.frame.size.height);
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLable];
        _titleLable = titleLable;
    }
    return _titleLable;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        CGFloat arrowWH = 15;
        arrowImageView.frame = CGRectMake(self.frame.size.width - arrowWH - 12, 28, arrowWH, arrowWH);
        [arrowImageView setImage:[UIImage imageNamed:@"TableViewArrow.png"]];
        [self.contentView addSubview:arrowImageView];
        _arrowImageView = arrowImageView;
    }
    return _arrowImageView;
}

@end
