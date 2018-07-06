//
//  NXPhotoConstant.h
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#ifndef NXPhotoConstant_h
#define NXPhotoConstant_h

@class UIImage;
@class NXGroupModel;
typedef NS_ENUM(NSInteger, NXPhotoLibarayAssertType) {
    
    NXPhotoLibarayAssertTypeAll,                 //相册所有元素
    NXPhotoLibarayAssertTypePhotos,              //所有图片
    NXPhotoLibarayAssertTypeVideo,               //所有视频
    NXPhotoLibarayAssertTypePanoramas,           //全景图片
    NXPhotoLibarayAssertTypeLivePhoto,           // livePhoto
    NXPhotoLibarayAssertTypeLivePhotoAndVideos,  // livePhoto和视频
};

typedef NS_ENUM(NSInteger, NXPhotoAssetType) {
    
    NXPhotoAssetTypeUnknown,             //位置类型
    NXPhotoAssetTypeImage,               //图片
    NXPhotoAssetTypeGif,                 // gif
    NXPhotoAssetTypeLiviePhoto,          // livePhoto
    NXPhotoAssetTypePhotoPanorama,       //全景照片
    NXPhotoAssetTypeVideo,               //视频
    NXPhotoAssetTypeVideoHighFrameRate,  //慢动作视频
    NXPhotoAssetTypeAudio,               //音频
    NXPhotoAssetTypeNetImage,
};

typedef NS_ENUM(NSInteger, NXAuthorizationStatus) {
    NXAuthorizationStatusNotDetermined = 0,  // 用户还没有关于这个应用程序做出了选择
    NXAuthorizationStatusRestricted,         // 这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
    NXAuthorizationStatusDenied,             // 用户已经明确否认了这个应用程序访问图片数据
    NXAuthorizationStatusAuthorized          // 用户授权此应用程序访问图片数据
};

typedef void (^fetchAlbumCompletion)(NSArray<NXGroupModel *> * _Nullable array);
typedef void (^downloadProgressBlock)(double progress);

typedef void (^requestImagSuccessBlock)(UIImage * _Nullable image);
typedef void (^requestFailBlock)(NSError * _Nullable error);

typedef void (^requestVideoSucces)(NSURL * _Nullable url);

typedef void (^deleteAssetCompletionBlock)(BOOL success, NSError* _Nullable error);

#endif /* NXPhotoConstant_h */
