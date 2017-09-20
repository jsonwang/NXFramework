//
//  NXLaunchVC.m
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "NXLaunchVC.h"
#import "NXWebVC.h"

#if __has_include(<UIImageView+WebCache.h>)

#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

#endif

@interface NXLaunchVC ()<UIScrollViewDelegate>
{
    NXLaunchType _launchType;
    NXImageLoadType _imageLoadType;
    NSArray * _imageArray;
    
    UIButton * _endButton;
    
    
    int rollX ;
    bool isReverse ;
    
    
}

@property(nonatomic,strong)NSTimer *timer;//广告计时器

@property(nonatomic,strong)UIButton *skipBtn;//广告倒计时

@property(nonatomic,strong)UIImageView *adImageView;//广告图片

@property(nonatomic,strong)UIImage *rollImage;//滚动图片

@property(nonatomic,strong)UIImageView *rollImageView;//滚动图片View

@property(nonatomic,strong)NSTimer *rollTimer;//滚动视图计时器

@end

@implementation NXLaunchVC
#pragma mark ---全局方法---

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adTime = 5;
    
    self.placeholderImageName = @"";
    self.adImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.frontGifView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.frontRollView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    rollX = 0;
    isReverse = NO;//是否反向翻滚
    
}

-(void)loadLauchViewWithLaunchType:(NXLaunchType)launchType
                     imageLoadType:(NXImageLoadType)imageLoadType
                        imageArray:(NSArray *)imageArray
{
    
    _launchType = launchType;
    _imageLoadType = imageLoadType;
    _imageArray = imageArray;
    
    if (_launchType != NXLaunchTypeAD)
    {//广告的 没有进入按钮
        [self loadEndButton];
    }
    
    if (_launchType == NXLaunchTypeScrollGuide)
    {//scroll的 有pageControl
        [self loadPageControl];
    }
    
    
    switch (_launchType)
    {
        case NXLaunchTypeAD:
        {//广告类型
            
            [self loadADImageView];
            
            [self loadTimer];
            
        }
            break;
            
        case NXLaunchTypeScrollGuide:
        {
            //轮播图
            [self loadImageScollView];
        }
            break;
            
        case NXLaunchTypeGif:
        {
            //gif
            [self loadGifImage];
            
        }
            break;
            
        case NXLaunchTypeRoll:
        {
            //滚动图
            [self loadRollImageView];
            
            
        }
            break;
            
        default:{
            
            NSLog(@"Error:类型错误!");
            
        }
            break;
    }
    
}

#pragma mark ---广告类型控制器相关方法---
-(void)loadADImageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushADWebVC)];
    [self.view addGestureRecognizer:tap];
    
    self.adImageView.frame =  CGRectMake(0, 20, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT - 20);
    
    [self.view addSubview:self.adImageView];
    
    if (_imageLoadType == ImageLoadTypeDownload)
    {
        if (_imageArray.count > 0)
        {
#if __has_include(<UIImageView+WebCache.h>)
            __weak typeof(self)temp = self;
        
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray firstObject]] placeholderImage:[UIImage imageNamed: self.placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [temp.view addSubview:temp.skipBtn];
                [temp.view bringSubviewToFront:temp.skipBtn];
                temp.adImageView.image = image;
                [temp.timer fire];
                
            }];
            
#endif
        }
    }
    else
    {
        NSMutableArray * imagesArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<_imageArray.count ; i++)
        {
            UIImage * adImage ;
            if(_imageLoadType == ImageLoadTypeLocalName)
            {
                adImage = [UIImage imageNamed:_imageArray[i]];
            }
            else
            {
                adImage = [UIImage imageWithContentsOfFile:[_imageArray objectAtIndex:i]];
            }
            if (adImage)
            {
                [imagesArray addObject:adImage];
            }
        }
        
        if (imagesArray.count == 1)
        {
            _adImageView.image = [imagesArray firstObject];
        }
        else
        {
            _adImageView.animationImages = imagesArray;
            _adImageView.animationDuration = self.adTime;
            _adImageView.animationRepeatCount = -1;
            [_adImageView startAnimating];
        }
    }
    
    
}

-(void)loadTimer
{
    
    if (self.skipImage)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(setAppMainViewController) userInfo:nil repeats:YES];

        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(NX_MAIN_SCREEN_WIDTH - 120, 40, 100, 40)];
        
        //设置跳过按钮文字
        if (self.skipTitle)
        {
            [_skipBtn setTitle:self.skipTitle forState:UIControlStateNormal];
        }
        
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _skipBtn.nx_x = NX_MAIN_SCREEN_WIDTH - _skipBtn.nx_width;
        
        [_skipBtn setBackgroundImage:self.skipImage forState:UIControlStateNormal];

        [_skipBtn addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
}

//计时器调取方法
-(void)setAppMainViewController
{
    if (!self.skipTitle)
    {
        [_skipBtn setTitle:[NSString stringWithFormat:@"(%d)",(int)self.adTime] forState:UIControlStateNormal];
    }
         
    if (self.skipImage)
    {
        self.adTime--;
        
        if (self.adTime < 0)
        {
            [self.timer invalidate];
            
            if (self.hideLaunchView)
            {
                self.hideLaunchView(nil);
            }
        }
    }
}

//停止计时器并且跳转到主控制器
-(void)skipAD
{
    if (self.timer !=nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.rollTimer != nil)
    {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
    
    if (self.hideLaunchView)
    {
        self.hideLaunchView(nil);
    }
    
}

//跳转到广告页面/指定info
-(void)pushADWebVC
{
    if ([NSString nx_isBlankString:self.adURL])
    {
        return;
    }
    
    [self.timer invalidate];
    
    if ([self.adURL hasPrefix:@"http"])
    {
        NXWebVC *webVC= [[NXWebVC alloc]init];
        webVC.backImage = [UIImage imageNamed:@"icon_back_normal"];
        webVC.backSelectImage = [UIImage imageNamed:@"icon_back_pressed"];
        
        __weak typeof(self) weakSelf = self;
        //当前页面要等广告页面disimiss的时候 再消失
        webVC.hideWebView = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.hideLaunchView)
            {
                strongSelf.hideLaunchView(nil);
            }
        };
        webVC.urlTitle = self.titleString;
        webVC.urlStr = self.adURL;
        [self presentViewController:webVC animated:YES completion:nil];
        
    }
    else
    {
        if (self.hideLaunchView)
        {
            self.hideLaunchView(self.adURL);
        }
    }
    
}


#pragma mark ---轮播图新手导引控制器相关方法---
-(void)loadImageScollView
{
    UIScrollView *imageScollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    imageScollView.delegate = self;
    
    for (int i = 0; i< _imageArray.count; i++)
    {   //添加图片
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(NX_MAIN_SCREEN_WIDTH * i, 0, NX_MAIN_SCREEN_WIDTH, NX_MAIN_SCREEN_HEIGHT)];
        
        switch (_imageLoadType)
        {
            case ImageLoadTypeDownload:
#if __has_include(<UIImageView+WebCache.h>)
                [imageView sd_setImageWithURL:_imageArray[i] placeholderImage:nil];
#endif
                //加载网络图片
                break;
            case ImageLoadTypeLocalName:
                imageView.image = [UIImage imageNamed:_imageArray[i]];
                //本地图片
                break;
            case ImageLoadTypeLocalPath:
                imageView.image = [UIImage imageWithContentsOfFile:_imageArray[i]];
                //本地path图片
                break;
                
            default:
                break;
        }
        
        
        [imageScollView addSubview:imageView];
        
        if (i == _imageArray.count - 1)
        {
            //最后一张图片加上进入按钮
            [imageView addSubview:_endButton];
            
            imageView.userInteractionEnabled = YES;
        }
    }
    
    imageScollView.contentSize = CGSizeMake(NX_MAIN_SCREEN_WIDTH * _imageArray.count, NX_MAIN_SCREEN_HEIGHT);
    imageScollView.pagingEnabled = YES;
    imageScollView.showsHorizontalScrollIndicator = NO;
    imageScollView.showsVerticalScrollIndicator =NO;
    imageScollView.bounces = NO;
    
    [self.view addSubview:imageScollView];
    
    [self.view addSubview:self.pageControl];
    
    _pageControl.numberOfPages = _imageArray.count;
    
    
}

//跳转按钮的
-(void)loadEndButton
{
    
    if (self.enterImage)
    {
        _endButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _endButton.frame = CGRectMake(NX_MAIN_SCREEN_WIDTH/2 - 60, NX_MAIN_SCREEN_HEIGHT - 120, 120, 40);
        
        _endButton.tintColor = [UIColor lightGrayColor];
        
        [_endButton setImage:self.enterImage forState:UIControlStateNormal];
        
        [_endButton addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
        
    }
}


-(void)loadPageControl
{
    
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,NX_MAIN_SCREEN_HEIGHT - 40,NX_MAIN_SCREEN_WIDTH, 40)];
    
    _pageControl.currentPage =0;
    
    //设置当前页指示器的颜色
    _pageControl.currentPageIndicatorTintColor =[UIColor blueColor];
    //设置指示器的颜色
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //获取偏移量
    NSInteger currentPage = scrollView.contentOffset.x/NX_MAIN_SCREEN_WIDTH;
    //改变PageControl的显示
    _pageControl.currentPage = currentPage;
    
    
}

#pragma mark ---GIF动态图控制器相关方法---

-(void)loadGifImage
{
    
    UIImageView *gifImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    if (_imageArray.count>0)
    {
#if __has_include(<UIImageView+WebCache.h>)
        
        if (_imageLoadType == ImageLoadTypeDownload)
        {
      
            [gifImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[0]]];

            
        }
        else
        {
            
            NSData *data = [NSData dataWithContentsOfFile:_imageArray[0]];
            
            gifImageView.image = [UIImage sd_animatedGIFWithData:data];
            
        }
#endif
    }
    
    
    [self.view addSubview:gifImageView];
    
    self.frontGifView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9  blue:0.9  alpha:0.5];
    
    if (_endButton)
    {
        [self.frontGifView addSubview:_endButton];
        
        _endButton.tintColor = [UIColor blueColor];
    }
    
    [self.view addSubview:self.frontGifView];
    
    
}

#pragma mark ---滚动图片控制器相关方法---


-(void)loadRollImageView
{
#if __has_include(<UIImageView+WebCache.h>)
    if (_imageArray.count>0)
    {
        if (_imageLoadType == ImageLoadTypeDownload)
        {
            [self downLoaderImageWithUrlString:_imageArray[0]];
            
        }
        else
        {
            _rollImage = [UIImage imageWithContentsOfFile:_imageArray[0] ];
            
            [self addRollImageAndTimer];
            
        }

    }
#endif
}

-(void)addRollImageAndTimer
{
    
    if (_rollImage != nil && _rollImage.size.height > _rollImage.size.width) {
        
        NSLog(@"Error:滚动图片的高度比宽度高,不能进行横向滚动!");
        
    }
    else
    {
        _rollImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,NX_MAIN_SCREEN_HEIGHT * _rollImage.size.width/_rollImage.size.height, NX_MAIN_SCREEN_HEIGHT)];
        
        _rollImageView.image = _rollImage;
        
        self.rollTimer =[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rollImageAction) userInfo:nil repeats:YES];
        
        [self.view addSubview:_rollImageView];
        
        
        if (_endButton)
        {
            [self.frontRollView addSubview:_endButton];
            
            _endButton.tintColor = [UIColor blueColor];
        }
        
        [self.view addSubview:self.frontRollView];
        
        [self.rollTimer fire];
    }
}

-(void)rollImageAction
{
    if (rollX-1 > (NX_MAIN_SCREEN_WIDTH - NX_MAIN_SCREEN_HEIGHT * _rollImage.size.width/_rollImage.size.height) &&!isReverse)
    {
        
        rollX = rollX-1;
        _rollImageView.frame = CGRectMake(rollX, 0,NX_MAIN_SCREEN_HEIGHT* _rollImage.size.width/_rollImage.size.height,NX_MAIN_SCREEN_HEIGHT);
        
    }
    else
    {
        
        isReverse = YES;
    }
    
    if (rollX+1 < 0 &&isReverse)
    {
        
        rollX = rollX +1;
        
        _rollImageView.frame = CGRectMake(rollX, 0,NX_MAIN_SCREEN_HEIGHT * _rollImage.size.width/_rollImage.size.height, NX_MAIN_SCREEN_HEIGHT);
        
    }
    else
    {
        isReverse = NO;
    }
    
}


-(void)downLoaderImageWithUrlString:(nonnull NSString *)string
{
    
    //1.准备URL
    NSURL *url = [NSURL URLWithString:string];
    
    //2.准备session
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)temp = self;
    
    //3.创建下载任务
    NSURLSessionDownloadTask *task  =[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *tmp = [NSData dataWithContentsOfURL:location];
        
        UIImage *img = [UIImage imageWithData:tmp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            temp.rollImage = img;
            
            [temp addRollImageAndTimer];
        });
        
    }];
    
    //4.执行任务
    [task resume];
    
}


-(void)dealloc
{
    if (self.timer !=nil)
    {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.rollTimer != nil)
    {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
    
    
}

@end
