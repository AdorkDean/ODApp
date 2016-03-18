//
//  UIView+ODExtension.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ODExtension)
@property(nonatomic, assign) CGSize od_size;
@property(nonatomic, assign) CGFloat od_width;
@property(nonatomic, assign) CGFloat od_height;
@property(nonatomic, assign) CGFloat od_x;
@property(nonatomic, assign) CGFloat od_y;
@property(nonatomic, assign) CGFloat od_centerX;
@property(nonatomic, assign) CGFloat od_centerY;

/**
 *  从xib加载View
 */
+ (instancetype)od_viewFromXib;

/**
 *  判断self和view是否重叠
 */
- (BOOL)od_intersectsWithView:(UIView *)view;

/**
 *  View的底部添加一条横线
 */
- (UIView *)addLineOnBottom;

/**
 *  在指定位置添加一条横线
 */
- (UIView *)addLineFromPoint:(CGPoint)point;

/**
 *  打电话
 */
- (void)callToNum:(NSString *)numString;



@end
