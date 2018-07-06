//
//  NXPhotoConfig.h
//  AFNetworking
//
//  Created by liuming on 2018/7/6.
//

#import <Foundation/Foundation.h>

@interface NXPhotoConfig : NSObject

+ (instancetype) shareInstanced;

/**
 图片裁剪大小
 */
@property(nonatomic,assign)CGSize clipSize;

/**
 打开 3dtouch预览
 */
@property(nonatomic,assign)BOOL open3DTouchPrev;
@end
