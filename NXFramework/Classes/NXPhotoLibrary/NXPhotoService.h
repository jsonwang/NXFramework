//
//  NXPhotoService.h
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#import <Foundation/Foundation.h>
#import "NXPhotoConstant.h"
#import "NXAssetModel.h"
#import "NXGroupModel.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/Photos.h>
#endif

@interface NXPhotoService : NSObject

+ (instancetype)shareInstanced NS_AVAILABLE_IOS(8_0);

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
///**
// 是否具有相册权限
//
// @return YES 已经授权 -- NO 未授权
// */
//+ (BOOL)hasAlbumAuthor;
//
//+ (void)requestAuthor:(void (^)(BOOL hasAuthor))block;
/**
 相册权限状态
 
 @return 权限状态枚举
 */
+ (NXAuthorizationStatus)albumPermissonStatues NS_AVAILABLE_IOS(8_0);

/**
 获取 获取用户所有相册列表
 
 @param completion 读取完成之后的回调
 */
- (void)fetchAllGroupsWithcompletion:(fetchAlbumCompletion)completion NS_AVAILABLE_IOS(8_0);

/**
 获取相册用户所有相册列表
 
 @param type 筛选type
 @param completion 完成回调
 */
- (void)fetchAllGroupsWithType:(NXPhotoLibarayAssertType)type completion:(fetchAlbumCompletion)completion NS_AVAILABLE_IOS(8_0);
/**
 获取相机胶卷相册列表对象
 
 @param type  筛选type
 @param completion 读取完成之后的回调
 */
- (void)fetchCameraRollAlbumListWithType:(NXPhotoLibarayAssertType)type completion:(fetchAlbumCompletion)completion NS_AVAILABLE_IOS(8_0);

#pragma mark--图片获取接口
- (PHImageRequestID)requestOriginalImageForAsset:(NXAssetModel *)asset
                                         success:(requestImagSuccessBlock)success
                                         failure:(requestFailBlock)failure
                                   progressBlock:(downloadProgressBlock)progressBlock NS_AVAILABLE_IOS(8_0);

/**
 * @brief 根据传入size获取图片
 */
- (PHImageRequestID)requestImageForAsset:(NXAssetModel *)asset
                                    size:(CGSize)size
                                 success:(requestImagSuccessBlock)success
                                 failure:(requestFailBlock)failure
                           progressBlock:(downloadProgressBlock)progressBlock NS_AVAILABLE_IOS(8_0);

#pragma 导出视频


- (PHImageRequestID)requestVideoWithAsset:(NXAssetModel *)asset
                                  success:(requestVideoSucces)success
                                  failure:(requestFailBlock)failure
                                 progress:(downloadProgressBlock)progressHandler NS_AVAILABLE_IOS(8_0);

- (void)requestVideoWithLivePhoto:(NXAssetModel *)assetModel succes:(requestVideoSucces)success failure:(requestFailBlock) failure;
#pragma mark - 图片和视频的保存

/**
 将本地图片存入系统相册
 
 @param imageUrl 图片路径
 @param cAlbumName 自定义相册
 @param completion 完成回调
 */
- (void)saveImageToAlblm:(NSURL *)imageUrl
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, NXAssetModel *))completion NS_AVAILABLE_IOS(8_0);

/**
 存入一张图片到系统相册
 
 @param image 图片对象
 @param cAlbumName 自定义相册
 @param completion 完成回调
 */
- (void)saveImageToAblum:(UIImage *)image
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, NXAssetModel *))completion NS_AVAILABLE_IOS(8_0);

/**
 存入一张图片到相册
 
 @param image 图片对象
 @param completion 完成回调
 */
- (void)saveImageToAblum:(UIImage *)image completion:(void (^)(BOOL, NXAssetModel *))completion NS_AVAILABLE_IOS(8_0);

/**
 保存视频到相册
 
 @param url 视频路径
 @param cAlbumName 自定义相册
 @param completion 完成回调
 */
- (void)saveVideoToAblum:(NSURL *)url
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, NXAssetModel *))completion NS_AVAILABLE_IOS(8_0);

/**
 保存视频到相册
 
 @param url 视频路径
 @param completion 完成回调
 */
- (void)saveVideoToAblum:(NSURL *)url completion:(void (^)(BOOL, NXAssetModel *))completion NS_AVAILABLE_IOS(8_0);

- (void)deleteMedaiWithAsset:(NXAssetModel *)asset
        withCunstomAlubmName:(NSString *)albumName
                  completion:(deleteAssetCompletionBlock)completion NS_AVAILABLE_IOS(8_0);

- (void)deleteMedaiWithAsset:(NXAssetModel *)asset completion:(deleteAssetCompletionBlock)completion NS_AVAILABLE_IOS(8_0);

#pragma mark -取消掉云端请求
- (void)cancelRequestID:(PHImageRequestID)requestId NS_AVAILABLE_IOS(8_0);

#pragma mark - 注册/移除 PHLibrary Observer
- (void)registerObserver:(id<PHPhotoLibraryChangeObserver>)observer NS_AVAILABLE_IOS(8_0);

- (void)removeRegisterObserver:(id<PHPhotoLibraryChangeObserver>)observer NS_AVAILABLE_IOS(8_0);

#endif
@end
