//
//  UIBarButtonItem+ODExtention.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBarButton.h"

@interface UIBarButtonItem (ODExtention)
+ (instancetype)OD_itemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage;

+ (instancetype)OD_itemWithTarget:(id)target action:(SEL)action color:(UIColor *)color highColor:(UIColor *)highColor title:(NSString *)title;

+ (instancetype)OD_itemWithType:(ODBarButtonType)barButtonType target:(id)target action:(SEL)action image:(UIImage *)image highImage:(UIImage *)highImage textColor:(UIColor *)textColor highColor:(UIColor *)highColor title:(NSString *)title;

@end
