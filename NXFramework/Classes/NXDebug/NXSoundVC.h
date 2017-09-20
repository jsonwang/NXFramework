//
//  NXSoundVC.h
//  Philm
//
//  Created by yoyo on 2017/8/24.
//  Copyright © 2017年 yoyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXSoundVC : UIViewController

@end

@interface NXSoundModel : NSObject

@property(nonatomic,assign) NSInteger sound_id;
@property(nonatomic,copy) NSString * sound_name;
@property(nonatomic,copy)NSString * sound_path;
@end
