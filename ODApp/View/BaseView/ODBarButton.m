//
//  ODBarButton.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBarButton.h"

@implementation ODBarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.imageView setOd_size:CGSizeMake(20, 20)];
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    switch (self.barButtonType)
    {
        case ODBarButtonImageLeft:
        {
            self.imageView.od_x = 0;
            self.imageView.od_y = (self.od_height - self.imageView.od_height) / 2;
            self.titleLabel.od_x = (self.od_width + CGRectGetMaxX(self.imageView.frame) - self.titleLabel.od_width) / 2;
            self.titleLabel.od_y = (self.od_height - self.titleLabel.od_height) / 2;
        }
            break;
        case ODBarButtonImageUp:
        {
            self.imageView.od_y = 0;
            self.imageView.od_x = (self.od_width - self.imageView.od_width) / 2;
            self.titleLabel.od_y = (self.od_height + CGRectGetMaxY(self.titleLabel.frame) - self.imageView.od_height) / 2;
            self.titleLabel.od_x = (self.od_width - self.titleLabel.od_width) / 2;
        }
            break;
        case ODBarButtonTextLeft:
        {
            self.titleLabel.od_x = 0;
            self.titleLabel.od_y = (self.od_height - self.titleLabel.od_height) / 2;
            self.imageView.od_x = (self.od_width + CGRectGetMaxX(self.titleLabel.frame) - self.imageView.od_width) / 2;
            self.imageView.od_y = (self.od_height - self.imageView.od_height) / 2;
        }
            break;
        case ODBarButtonTextUp:
        {
            self.titleLabel.od_y = 0;
            self.titleLabel.od_x = (self.od_width - self.titleLabel.od_width) / 2;
            self.imageView.od_y = (self.od_height + CGRectGetMaxY(self.imageView.frame) - self.titleLabel.od_height) / 2;
            self.imageView.od_x = (self.od_width - self.imageView.od_width) / 2;
        }
            break;
        default:
            break;
    }
}

@end
