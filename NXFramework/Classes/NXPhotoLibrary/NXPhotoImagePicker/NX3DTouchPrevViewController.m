//
//  NX3DTouchPrevViewController.m
//  NXFramework
//
//  Created by liuming on 2018/7/6.
//

#import "NX3DTouchPrevViewController.h"
#import "NXPhotoService.h"
#import "SVProgressHUD.h"
#import "VPImageCropperViewController.h"
@interface NX3DTouchPrevViewController ()
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UIImage * image;
@end

@implementation NX3DTouchPrevViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图片预览";
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    [[NXPhotoService shareInstanced] requestOriginalImageForAsset:self.assetModel success:^(UIImage * _Nullable image) {
        [SVProgressHUD dismiss];
        self.imageView.image = image;
        self.image = image;
    } failure:nil progressBlock:^(double progress) {
        if(![SVProgressHUD isVisible]) {
            [SVProgressHUD showWithStatus:@"正在加载中...."];
        }
    }];
    
}

#pragma mark - 3D Touch 预览Action代理
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    NSMutableArray *arrItem = [NSMutableArray array];
    
    UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"didClickCancel");
    }];
    
    UIPreviewAction *previewAction1 = [UIPreviewAction actionWithTitle:@"选择" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        //把下标为index的元素替换成preview
        [self replaceItem];
        
    }];
    
    [arrItem addObjectsFromArray:@[previewAction0 ,previewAction1]];
    
    return arrItem;
}

- (void)replaceItem
{
    
    if(self.seletedImageBlock){
        self.seletedImageBlock(self.image);
    }
//    if (self.arrData.count<=0) return ;
//    [self.arrData replaceObjectAtIndex:self.index withObject:@"replace  item"];
    
    //发送通知更新数据
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_RELOADDATA" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
