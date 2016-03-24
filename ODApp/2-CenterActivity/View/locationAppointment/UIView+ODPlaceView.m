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
    self.layer.borderColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1].CGColor;
    self.layer.borderWidth = 1;
}
@end
