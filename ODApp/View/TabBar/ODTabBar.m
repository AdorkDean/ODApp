//
//  ODTabBar.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#define KBaseTag 2500

#import "ODTabBar.h"

@implementation ODTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    }
    return self;
}

- (void)buttonClick:(UIControl *)control
{
     if ([self.od_delegate respondsToSelector:@selector(od_tabBar:selectIndex:)])
    {
        [_od_delegate od_tabBar:self selectIndex:control.tag - KBaseTag];
    }
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, kScreenSize.height - ODTabBarHeight, kScreenSize.width, ODTabBarHeight);
    UIView * transitionView = self.subviews[0];
    transitionView.od_height = self.od_y;
    NSInteger tabBarButtonIndex = 0;
    for (UIControl *control in self.subviews)
    {
        if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            control.frame = CGRectMake(control.od_x, 0, self.od_width / 5, self.od_height);

            control.tag = KBaseTag + tabBarButtonIndex;
            [control addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            for (UIView *subView in control.subviews)
            {
                if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")])
                {
                    subView.contentMode = UIViewContentModeScaleAspectFit;
                    subView.frame = CGRectMake(0, 7.5, self.od_width / 5, 25);
                }
                else if ([subView isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")])
                {
                    [subView setValue:@(NSTextAlignmentCenter) forKeyPath:@"textAlignment"];
                    [subView setValue:[UIColor colorWithHexString:@"#484848" alpha:1] forKeyPath:@"textColor"];
                    subView.frame = CGRectMake(0, 37, self.od_width / 5, 18);
                }
            }
            tabBarButtonIndex ++;
        }
    }
}

@end
