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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.tintColor = [UIColor colorGloomyColor];
    }
    return self;
}

- (void)buttonClick:(UIControl *)control {
    if ([self.od_delegate respondsToSelector:@selector(od_tabBar:selectIndex:)]) {
        [_od_delegate od_tabBar:self selectIndex:control.tag - KBaseTag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, kScreenSize.height - ODTabBarHeight, kScreenSize.width, ODTabBarHeight);
    UIView *transitionView = self.subviews[0];
    transitionView.od_height = self.od_y;
    for (UIControl *control in self.subviews) {
        if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [control addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventAllEvents];
            for (UIView *subView in control.subviews) {
                if ([subView isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
                    @try {
                        control.tag = KBaseTag + [[self.items valueForKeyPath:@"title"] indexOfObject:[subView valueForKeyPath:@"text"]];
                    }
                    @catch (NSException *exception) {

                    }
                }
            }
        }
    }
}

@end
