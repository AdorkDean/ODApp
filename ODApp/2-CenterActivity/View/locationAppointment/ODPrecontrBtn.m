//
//  ODPrecontrBtn.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPrecontrBtn.h"
#import "UIView+ODPlaceView.h"

@implementation ODPrecontrBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    [self od_setBorder];
    self.titleLabel.font = [UIFont systemFontOfSize:12.5];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"484848" alpha:1];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    self.titleLabel.od_x = 17 / 2;
    self.titleLabel.od_y = (self.od_height - self.titleLabel.od_height) / 2;
    self.imageView.center = CGPointMake(self.od_width - self.imageView.od_width / 2 - 5, self.od_height / 2);
}
@end
