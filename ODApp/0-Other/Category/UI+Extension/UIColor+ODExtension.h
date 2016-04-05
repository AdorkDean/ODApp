//
//  UIColor+ODExtension.h
//  ODApp
//
//  Created by Odong-YG on 16/1/19.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ODExtension)

/**
 *  随机颜色
 */
+ (UIColor *)randomColor;

/**
 *  不带有透明度的RGB颜色设置
 */
+ (UIColor *)colorWithRGBString:(NSString *)rgbString;

/**
 *  带有透明度的RGB颜色设置
 */
+ (UIColor *)colorWithRGBString:(NSString *)rgbString alpha:(float)opacity;


@end
