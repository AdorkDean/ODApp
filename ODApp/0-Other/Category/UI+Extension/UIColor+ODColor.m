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
    return [UIColor colorWithHexString:@"#ffd802" alpha:1];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
}

+ (UIColor *)colorWhiteColor
{
    return [UIColor colorWithHexString:@"#ffffff" alpha:1];
}

+ (UIColor *)colorRedColor
{
    return [UIColor colorWithHexString:@"#ff6666" alpha:1];
}

+ (UIColor *)colorBlackColor
{
    return [UIColor colorWithHexString:@"#000000" alpha:1];
}

+ (UIColor *)colorGrayColor
{
    return [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
}

+ (UIColor *)colorGloomyColor
{
    return [UIColor colorWithHexString:@"#484848" alpha:1];
}

+ (UIColor *)colorGraynessColor
{
    return [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
}

@end
