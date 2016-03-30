//
//  ODHomeButton.m
//  ODApp
//
//  Created by Odong-YG on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODHomeButton.h"

@implementation ODHomeButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = (KScreenWidth - 2 * ODLeftMargin) / 4;
    self.imageView.od_centerX = width / 2;
    self.titleLabel.od_centerX = width / 2;
    self.imageView.od_y = ODLeftMargin;
    self.titleLabel.od_y = 55;
}
@end
