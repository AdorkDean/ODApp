//
//  ODPlacePrecontrHeaderView.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPlacePrecontrHeaderView.h"

@implementation ODPlacePrecontrHeaderView

- (CGFloat)viewHeight
{
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.placeBtn.frame);
}

- (void)reback
{
    [self.startTimeBtn setTitle:@"请填写开始时间" forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:@"请填写结束时间" forState:UIControlStateNormal];
}
@end
