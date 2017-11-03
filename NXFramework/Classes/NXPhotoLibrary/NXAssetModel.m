//
//  NXAssetModel.m
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#import "NXAssetModel.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/PHAsset.h>
#endif


@implementation NXAssetModel

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
        self.medaiType = [self transformAssetType:_asset];
    }
    return self;
}

//系统mediatype 转换为 自定义type
- (NXPhotoAssetType)transformAssetType:(PHAsset *)asset
{
    switch (asset.mediaType)
    {
        case PHAssetMediaTypeAudio:
            return NXPhotoAssetTypeAudio;
        case PHAssetMediaTypeVideo:
        {
            if (self.asset.mediaSubtypes == PHAssetMediaSubtypeVideoHighFrameRate)
            {
                return NXPhotoAssetTypeVideoHighFrameRate;
            }
            return NXPhotoAssetTypeVideo;
        }
        case PHAssetMediaTypeImage:
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) return NXPhotoAssetTypeGif;
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 10)
                return NXPhotoAssetTypeLiviePhoto;
            if(asset.mediaSubtypes == PHAssetMediaSubtypePhotoPanorama)
                return NXPhotoAssetTypePhotoPanorama;
            return NXPhotoAssetTypeImage;
        default:
            return NXPhotoAssetTypeUnknown;
    }
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    NXAssetModel *assetModel = [[[self class] alloc] initWithAsset:_asset];
    return assetModel;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    NXAssetModel *assetModel = [[[self class] alloc] initWithAsset:_asset];
    return assetModel;
}
@end
