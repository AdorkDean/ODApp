//
//  ODNavigationBarView.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationBarView.h"

@interface ODNavigationBarView ()

/** 标题label */
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation ODNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor themeColor];
    }
    return self;
}

+ (instancetype)navigationBarView
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, ODNavigationHeight)];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((kScreenSize.width - self.titleLabel.od_width) / 2, [self getYFromBtn:self.titleLabel], self.titleLabel.od_width, self.titleLabel.od_height);
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
