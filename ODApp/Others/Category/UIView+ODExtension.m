//
//  UIView+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "UIView+ODExtension.h"

@implementation UIView (ODExtension)

+ (instancetype)od_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (BOOL)od_intersectsWithView:(UIView *)view
{
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (CGSize)od_size
{
    return self.frame.size;
}

- (void)setOd_size:(CGSize)od_size
{
    CGRect frame = self.frame;
    frame.size = od_size;
    self.frame = frame;
}

- (CGFloat)od_width
{
    return self.frame.size.width;
}

- (CGFloat)od_height
{
    return self.frame.size.height;
}

- (void)setOd_width:(CGFloat)od_width
{
    CGRect frame = self.frame;
    frame.size.width = od_width;
    self.frame = frame;
}

- (void)setOd_height:(CGFloat)od_height
{
    CGRect frame = self.frame;
    frame.size.height = od_height;
    self.frame = frame;
}

- (CGFloat)od_x
{
    return self.frame.origin.x;
}

- (void)setOd_x:(CGFloat)od_x
{
    CGRect frame = self.frame;
    frame.origin.x = od_x;
    self.frame = frame;
}

- (CGFloat)od_y
{
    return self.frame.origin.y;
}

- (void)setOd_y:(CGFloat)od_y
{
    CGRect frame = self.frame;
    frame.origin.y = od_y;
    self.frame = frame;
}

- (CGFloat)od_centerX
{
    return self.center.x;
}

- (void)setOd_centerX:(CGFloat)od_centerX
{
    CGPoint center = self.center;
    center.x = od_centerX;
    self.center = center;
}

- (CGFloat)od_centerY
{
    return self.center.y;
}

- (void)setOd_centerY:(CGFloat)od_centerY
{
    CGPoint center = self.center;
    center.y = od_centerY;
    self.center = center;
}

- (void)addLineOnBottom
{
    [self addLineFromPoint:CGPointMake(0, self.od_height)];
}

- (void)addLineFromPoint:(CGPoint)point
{
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(point.x, point.y - .5, KScreenWidth + ODLeftMargin, .5);
    lineView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6" alpha:1];
    [self addSubview:lineView];
}
@end
