//
//  NX3DTouchPrevViewController.h
//  NXFramework
//
//  Created by liuming on 2018/7/6.
//

#import <UIKit/UIKit.h>
#import "NXAssetModel.h"
@interface NX3DTouchPrevViewController : UIViewController

@property(nonatomic,copy)void (^seletedImageBlock)(UIImage * image);
@property(nonatomic,strong)NXAssetModel * assetModel;
@end
