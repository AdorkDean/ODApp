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
    ODBarButton *button = [ODBarButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage ? highImage : image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)OD_itemWithTarget:(id)target action:(SEL)action color:(UIColor *)color highColor:(UIColor *)highColor title:(NSString *)title
{
    ODBarButton *button = [ODBarButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color ? color : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highColor ? highColor : [UIColor blackColor] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc]initWithCustomView:button];
}

+ (instancetype)OD_itemWithType:(ODBarButtonType)barButtonType target:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage textColor:(UIColor *)textColor highColor:(UIColor *)highColor title:(NSString *)title
{
    ODBarButton *button = [ODBarButton buttonWithType:UIButtonTypeCustom];
    button.barButtonType = barButtonType;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor ? textColor : [UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:highColor ? highColor : [UIColor blackColor] forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage ? highImage : image forState:UIControlStateHighlighted];
    [button.imageView sizeToFit];
    [button.titleLabel sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc]initWithCustomView:button];
}

@end
