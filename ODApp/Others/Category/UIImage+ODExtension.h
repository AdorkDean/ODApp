//
//  UIImage+ODExtension.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ODExtension)
/**
 *  颜色转图片
 */
+ (UIImage *)OD_imageWithColor:(UIColor *)color;
/**
 *  把image裁剪成圆形图片
 */
- (instancetype)OD_circleImage;
/**
 *  根据图片名字转换成圆形图片
 */
+ (instancetype)OD_circleImageNamed:(NSString *)name;

@end
