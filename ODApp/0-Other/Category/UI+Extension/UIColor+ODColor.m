//
//  UIColor+ODColor.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "UIColor+ODColor.h"

@implementation UIColor (ODColor)

+ (UIColor *)themeColor
{
    return [UIColor colorWithRGBString:@"#ffd802" alpha:1];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
}


+ (UIColor *)colorRedColor
{
    return [UIColor colorWithRGBString:@"#ff6666" alpha:1];
}


+ (UIColor *)colorGrayColor
{
    return [UIColor colorWithRGBString:@"#d0d0d0" alpha:1];
}

+ (UIColor *)colorGloomyColor
{
    return [UIColor colorWithRGBString:@"#484848" alpha:1];
}

+ (UIColor *)colorGraynessColor
{
    return [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
}

@end
