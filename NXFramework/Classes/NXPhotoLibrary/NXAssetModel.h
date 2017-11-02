//
//  NXAssetModel.h
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#import <Foundation/Foundation.h>
#import "NXPhotoConstant.h"
@class PHAsset;

@interface NXAssetModel : NSObject
- (instancetype)initWithAsset:(PHAsset *)asset;

@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, assign) NXPhotoAssetType medaiType;
@end
