//
//  NXPhotoConfig.h
//  AFNetworking
//
//  Created by liuming on 2018/7/6.
//

#import <Foundation/Foundation.h>

@interface NXPhotoConfig : NSObject

/**
 图片裁剪大小
 */
@property(nonatomic,assign)CGSize clipSize;

+ (instancetype) shareInstanced;
@end
