//
//  ODActiveDeviceBtn.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActiveDeviceBtn.h"

@implementation ODActiveDeviceBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    [self setImage:[UIImage imageNamed:@"gouxuan_unselected_icon"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"gouxuan_selected_icon"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [self setTitleColor:[UIColor colorWithRGBString:@"484848" alpha:1] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    self.od_height = 30;
    self.imageView.od_x = 8.5;
    self.imageView.od_y = (self.od_height - self.imageView.od_height) / 2;
    self.titleLabel.od_x = CGRectGetMaxX(self.imageView.frame) + 7.5;
    self.titleLabel.od_y = (self.od_height - self.titleLabel.od_height) / 2;
}

- (void)selectClick:(ODActiveDeviceBtn *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(activeDeviceBtnClicked:)])
    {
        [self.delegate activeDeviceBtnClicked:btn];
    }
}

- (void)setHighlighted:(BOOL)highlighted{}

@end
