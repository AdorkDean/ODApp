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
@end
