//
//  ODActivityDetailBtn.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityDetailBtn.h"

@implementation ODActivityDetailBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
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
- (void)setOD_selectedState:(BOOL)OD_selectedState
{
    _OD_selectedState = OD_selectedState;
    if (OD_selectedState)
    {
        [self setImage:[self imageForState:UIControlStateSelected] forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[self imageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected
{
}
@end
