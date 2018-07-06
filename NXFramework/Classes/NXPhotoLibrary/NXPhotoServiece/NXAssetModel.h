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
- (instancetype)initWithAsset:(PHAsset *)asset NS_AVAILABLE_IOS(8_0);

@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, assign) NXPhotoAssetType medaiType;
@end
