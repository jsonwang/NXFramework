//
//  QYMonitorItem.m
//  MonitorTool
//
//  Created by liuming on 16/9/30.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "NXMonitorItem.h"
#define scaleHeightOfTitle 0.4f  //标题文本占整个 NX_DMItemHeight的比例
@interface NXMonitorItem ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dataLabel;
@end
@implementation NXMonitorItem
- (double)width { return self.frame.size.width; }
- (double)height { return self.frame.size.height; }
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
    }

    return self;
}

- (void)initSubViews
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height * scaleHeightOfTitle)];
    self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height * scaleHeightOfTitle, self.width,
                                                               self.height * (1 - scaleHeightOfTitle))];
    [self configLabelStyle:self.titleLabel];
    [self configLabelStyle:self.dataLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.dataLabel];
}

- (void)configLabelStyle:(UILabel *)label
{
    if (label)
    {
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
}
- (void)setTitleString:(NSString *)titleString { self.titleLabel.text = titleString; }
- (void)setDataString:(NSString *)dataString
{
    if (dataString.length == 0)
    {
        self.titleLabel.frame = self.bounds;
    }
    else
    {
        self.titleLabel.frame = CGRectMake(0, 0, self.width, self.height * scaleHeightOfTitle);
        self.dataLabel.frame =
            CGRectMake(0, self.height * scaleHeightOfTitle, self.width, self.height * (1 - scaleHeightOfTitle));
    }
    self.dataLabel.text = dataString;
}

@end
