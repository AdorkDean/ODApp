//
//  UIBarButtonItem+ODExtention.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "UIBarButtonItem+ODExtention.h"

@implementation UIBarButtonItem (ODExtention)

+ (instancetype)OD_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]  forState:UIControlStateNormal];
    [button setImage:[highImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)OD_itemWithTarget:(id)target action:(SEL)action color:(UIColor *)color highColor:(UIColor *)highColor title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color ? color : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highColor ? highColor : [UIColor blackColor] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc]initWithCustomView:button];
}
@end
