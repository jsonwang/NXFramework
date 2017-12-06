//
//  NXSegmentView.m
//  NXlib
//
//  Created by AK on 2016/12/5.
//  Copyright © 2016年 yoyo. All rights reserved.
//

#import "NXSegmentView.h"
#import "NXConfig.h"


@interface NXSegmentView ()
// 高度
@property(nonatomic, assign) CGFloat menuHeight;

@property(nonatomic, strong) NSMutableArray *btnArrys;

@property(nonatomic, strong) UIButton *titleBtn;
@property(nonatomic, strong) UIScrollView *BackScrollView;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, assign) CGFloat btnWidth;

@end

@implementation NXSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.menuHeight = frame.size.height;
        self.defaultIndex = 1;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.titleFont = [UIFont systemFontOfSize:15];
        self.btnArrys = [[NSMutableArray alloc] initWithCapacity:0];
        
        //文字色默认值
        self.titleColorNormal = NX_RGB(80, 80, 80);
        self.titleColorSelect = NX_RGB(30, 137, 255);
        //线色默认值
        self.lineColorNormal = NX_RGB(214, 214, 214);
        self.lineColorSelect = NX_RGB(0, 96, 255);
        self.isBarEqualParts = YES;
        self.itemMargin = 15.0f;
        
        self.BackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), self.menuHeight)];
        self.BackScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.BackScrollView];
        
        [self registerForKVO];
    }
    return self;
}
- (void)registerForKVO
{
    for (NSString *keyPath in [self observableKeypaths])
    {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (NSArray *)observableKeypaths
{
    return [NSArray arrayWithObjects:@"titleColorNormal", @"titleColorSelect", @"titleFont", @"defaultIndex",
            @"bottomLineColor", @"titleLineColor", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updateUIForKeypath:keyPath];
}
/**观察改变属性*/
- (void)updateUIForKeypath:(NSString *)keyPath
{
    if ([keyPath isEqualToString:@"titleColorNormal"])
    {
        [self updaeViewUI:^(UIButton *btn) {
            [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
        }];
    }
    else if ([keyPath isEqualToString:@"titleColorSelect"])
    {
        [self updaeViewUI:^(UIButton *btn) {
            [btn setTitleColor:self.titleColorSelect forState:UIControlStateSelected];
        }];
    }
    else if ([keyPath isEqualToString:@"titleFont"])
    {
        [self updaeViewUI:^(UIButton *btn) {
            [btn.titleLabel setFont:self.titleFont];
        }];
    }
    else if ([keyPath isEqualToString:@"defaultIndex"])
    {
        [self updaeViewUI:^(UIButton *btn) {
            if (btn.tag - 1 == self.defaultIndex - 1)
            {
                self.titleBtn = btn;
                btn.selected = YES;
                /**设置默认选中的下划线位置*/
                [self selectDefaultBottomAndVC:self.defaultIndex];
            }
            else
            {
                btn.selected = NO;
            }
        }];
    }
    else if ([keyPath isEqualToString:@"lineColorNormal"])
    {
        UIView *line = [self viewWithTag:1100];
        line.backgroundColor = self.lineColorNormal;
    }
    else if ([keyPath isEqualToString:@"lineColorSelect"])
    {
        //设置选中后下边线的颜色
        self.bottomLine.backgroundColor = self.lineColorSelect;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)updaeViewUI:(void (^)(UIButton *btn))complated
{
    for (UIButton *btn in self.btnArrys)
    {
        [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColorSelect forState:UIControlStateSelected];
        btn.titleLabel.font = self.titleFont;
        if (complated)
        {
            complated(btn);
        }
    }
}

- (void)dealloc { [self unregisterFromKVO]; }
- (void)unregisterFromKVO
{
    for (NSString *keyPath in [self observableKeypaths])
    {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

/**懒加载底部横线*/
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [[UIView alloc]
                       initWithFrame:CGRectMake(0, self.menuHeight - BottomLineHeight, self.btnWidth, BottomLineHeight)];
        
        _bottomLine.backgroundColor = self.lineColorSelect;
        [_BackScrollView addSubview:_bottomLine];
    }
    return _bottomLine;
}

/**画标题*/
- (void)setTitleArry:(NSArray *)titleArry
{
    if (!titleArry) return;
    
    _titleArry = titleArry;
    if (_titleArry.count <= 6)
    {
        self.btnWidth = NX_MAIN_SCREEN_WIDTH / _titleArry.count;
    }
    else
    {
        self.btnWidth = NX_MAIN_SCREEN_WIDTH / 6;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.menuHeight - BottomLineHeight,
                                                            self.btnWidth * _titleArry.count, BottomLineHeight)];
    line.backgroundColor = self.lineColorNormal;
    line.tag = 1100;
    [self.BackScrollView addSubview:line];
    
    // 重置横线位置
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.bottomLine.frame =
                         CGRectMake(0, self.menuHeight - BottomLineHeight, self.btnWidth, BottomLineHeight);
                     }];
    
    
    if(self.isBarEqualParts)
    {
        self.BackScrollView.contentSize = CGSizeMake(self.btnWidth * _titleArry.count, self.menuHeight);
        
        for (int i = 0; i < _titleArry.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.btnWidth * i, 0, self.btnWidth, self.menuHeight - BottomLineHeight);
            btn.tag = i + 1;
            [btn setTitle:_titleArry[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColorSelect forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchDown];
            // 这里设置修改标题栏的背景颜色
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleLabel.font = _titleFont;
            [self.BackScrollView addSubview:btn];
            
            [self.btnArrys addObject:btn];
            if (i == 0)
            {
                _titleBtn = btn;
                btn.selected = YES;
            }
        }
        
    } else {
        
        CGFloat item_X = 0;
        for (NSInteger i = 0; i < _titleArry.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 1;
            btn.titleLabel.font = _titleFont;
            [btn setTitle:_titleArry[i] forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
            [btn setTitleColor:self.titleColorSelect forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 这里设置修改标题栏的背景颜色
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            [self.BackScrollView addSubview:btn];
            
            CGRect rect = [_titleArry[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_titleFont,NSFontAttributeName, nil] context:nil];
            btn.frame = CGRectMake(item_X, 0, rect.size.width + 2*self.itemMargin, self.menuHeight - BottomLineHeight);
            
            item_X += rect.size.width + 2 * self.itemMargin;
            [self.btnArrys addObject:btn];
        }
        self.BackScrollView.contentSize = CGSizeMake(item_X,self.menuHeight);
    }
    
    line.frame = CGRectMake(0, CGRectGetMinY(line.frame), self.BackScrollView.contentSize.width, CGRectGetHeight(line.frame));
}
#pragma mark - title点击事件
- (void)btnTitleClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segment:didSelectColumnIndex:selectColumStr:)])
    {
        [self.delegate segment:self didSelectColumnIndex:sender.tag selectColumStr:self.titleArry[sender.tag - 1]];
    }
    
    if (sender.tag == self.defaultIndex)
    {
        return;
    }
    else
    {
        self.titleBtn.selected = NO;
        sender.selected = YES;
        self.titleBtn = sender;
        self.defaultIndex = sender.tag;
    }
    //计算偏移量
    CGFloat offsetX = sender.frame.origin.x - 2 * self.btnWidth;
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.BackScrollView.contentSize.width - NX_MAIN_SCREEN_WIDTH;
    if (offsetX > maxOffsetX)
    {
        offsetX = maxOffsetX;
    }
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.BackScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                         self.bottomLine.frame =
                         CGRectMake(sender.frame.origin.x, self.frame.size.height - BottomLineHeight,
                                    sender.frame.size.width, BottomLineHeight);
                     }];
}

- (void)selectDefaultBottomAndVC:(NSInteger)defaultIndex
{
    UIButton *sender = [self.btnArrys objectAtIndex:defaultIndex - 1];
    //计算偏移量
    CGFloat offsetX = sender.frame.origin.x - 2 * self.btnWidth;
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.BackScrollView.contentSize.width - NX_MAIN_SCREEN_WIDTH;
    if (offsetX > maxOffsetX)
    {
        offsetX = maxOffsetX;
    }
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.BackScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                         self.bottomLine.frame =
                         CGRectMake(sender.frame.origin.x, self.frame.size.height - BottomLineHeight,
                                    sender.frame.size.width, BottomLineHeight);
                     }];
}

- (void)scrollMenuViewSelectedoffsetX:(NSInteger)selectIndex withOffsetType:(BOOL)types
{
    // 默认选中
    self.defaultIndex = selectIndex + 1;
    //计算偏移量
    CGFloat offsetX = (selectIndex - 2) * self.btnWidth;
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.BackScrollView.contentSize.width - NX_MAIN_SCREEN_WIDTH;
    if (offsetX > maxOffsetX)
    {
        offsetX = maxOffsetX;
    }
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.BackScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                         if (types)
                         {
                             self.bottomLine.frame =
                             CGRectMake(selectIndex * self.btnWidth, self.menuHeight - BottomLineHeight,
                                        self.btnWidth, BottomLineHeight);
                         }
                     }];
}

- (void)resetFrame:(CGRect )rect
{
    self.frame = rect;
    self.BackScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.menuHeight);
}
@end
