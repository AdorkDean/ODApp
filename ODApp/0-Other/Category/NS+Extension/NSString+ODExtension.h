//
//  NSString+ODExtension.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

@interface NSString (ODExtension)

/**
 *  判断字符串内容是否全部为空格
 */
- (BOOL)isBlank;

/**
 *  计算文字Size
 */
- (CGSize)od_SizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (CGSize)od_SizeWithFont:(UIFont *)font;

@end
