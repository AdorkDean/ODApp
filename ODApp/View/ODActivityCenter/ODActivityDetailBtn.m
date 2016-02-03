//
//  ODActivityDetailBtn.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityDetailBtn.h"

@implementation ODActivityDetailBtn

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    self.imageView.center = CGPointMake(50 + (self.titleLabel.od_width) / 2, self.od_centerY);
    self.titleLabel.center = CGPointMake(CGRectGetMaxX(self.imageView.frame) + 12.5 + self.titleLabel.od_width / 2, self.od_centerY);
}

@end
