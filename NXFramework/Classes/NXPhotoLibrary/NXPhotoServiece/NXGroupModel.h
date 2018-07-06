//
//  NXGroupModel.h
//  NXFramework
//
//  Created by liuming on 2017/11/2.
//

#import <Foundation/Foundation.h>
@class PHAssetCollection;
@class NXAssetModel;
@interface NXGroupModel : NSObject

@property(nonatomic, strong) PHAssetCollection* collection;
@property(nonatomic, strong) NSMutableArray<NXAssetModel *>* asstArray;  ///<* 筛选出的
@property(nonatomic, assign) NSInteger count;

@end
