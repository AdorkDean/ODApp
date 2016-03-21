//
//  ODCustomButton.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCustomButton.h"

static CGFloat const scale = 0.6;

@implementation ODCustomButton

- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    self.imageView.contentMode = UIViewContentModeCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 图片
    self.imageView.od_x = 0;
    self.imageView.od_y = 0;
    self.imageView.od_width = self.od_width;
    self.imageView.od_height = self.od_height * scale;
    // 文字
    self.titleLabel.od_x = 0;
    self.titleLabel.od_y = self.imageView.od_height;
    self.titleLabel.od_width = self.od_width;
    self.titleLabel.od_height = self.od_height - self.imageView.od_height;
}

@end
