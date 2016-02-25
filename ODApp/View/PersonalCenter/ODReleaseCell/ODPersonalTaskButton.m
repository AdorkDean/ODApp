//
//  ODPersonalTaskButton.m
//  ODApp
//
//  Created by 代征钏 on 16/2/19.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPersonalTaskButton.h"

@implementation ODPersonalTaskButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgWidth = self.imageView.od_width;
    CGFloat titWidth = self.titleLabel.od_width;
    CGFloat allWidth = imgWidth + titWidth + 12.5;
    self.imageView.od_x = (self.od_width - allWidth) / 2;
    self.titleLabel.od_x = CGRectGetMaxX(self.imageView.frame) + 12.5;
}

@end
