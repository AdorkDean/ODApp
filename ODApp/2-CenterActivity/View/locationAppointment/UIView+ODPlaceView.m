//
//  UIView+ODPlaceView.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "UIView+ODPlaceView.h"

@implementation UIView (ODPlaceView)

- (void)od_setBorder
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 1;
}
@end
