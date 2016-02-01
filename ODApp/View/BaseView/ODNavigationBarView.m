//
//  ODNavigationBarView.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationBarView.h"

@implementation ODNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffd802" alpha:1];
    }
    return self;
}

+ (instancetype)navigationBarView
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, ODNavigationHeight)];
}

- (void)setTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.frame = CGRectMake((kScreenSize.width - label.od_width) / 2, [self getYFromBtn:label], label.od_width, label.od_height);
    [self addSubview:label];
}

- (void)setLeftBarButton:(ODBarButton *)leftBarButton
{
    leftBarButton.frame = CGRectMake(ODLeftMargin, [self getYFromBtn:leftBarButton],leftBarButton.od_width, leftBarButton.od_height);
    if ([self.subviews containsObject:leftBarButton])
        return;
    [self addSubview:leftBarButton];
    _leftBarButton = leftBarButton;
}

- (void)setRightBarButton:(ODBarButton *)rightBarButton
{
    rightBarButton.frame = CGRectMake(kScreenSize.width - rightBarButton.od_width - ODLeftMargin,[self getYFromBtn:rightBarButton],rightBarButton.od_width, rightBarButton.od_height);
    if ([self.subviews containsObject:rightBarButton])
        return;
    [self addSubview:rightBarButton];
    _rightBarButton = rightBarButton;
}

- (CGFloat)getYFromBtn:(UIView *)view
{
    return (self.od_height - view.od_height ) / 2 + 10;
}

@end
