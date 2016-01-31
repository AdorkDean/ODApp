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
        // 左边button
        ODBarButton *leftBtn = [ODBarButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:leftBtn];
        self.leftBarButton = leftBtn;
        // 右边button
        ODBarButton *rightBtn = [ODBarButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:rightBtn];
        self.rightBarButton = rightBtn;
    }
    return self;
}

+ (instancetype)navigationBarView
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, ODNavigationHeight)];
}

- (void)setLeftBarButton:(ODBarButton *)leftBarButton
{
    _leftBarButton = leftBarButton;
    _leftBarButton.frame = CGRectMake(17.5, (self.od_height - leftBarButton.od_height ) / 2 - 10,leftBarButton.od_width, leftBarButton.od_height);
}

- (void)setRightBarButton:(ODBarButton *)rightBarButton
{
    _rightBarButton = rightBarButton;
    _rightBarButton.frame = CGRectMake(kScreenSize.width - 60,(self.od_height - rightBarButton.od_height ) / 2,rightBarButton.od_width, rightBarButton.od_height);
}

- (void)setTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
}
@end
