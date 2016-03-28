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
 *  限制文字的Size, 计算文字实际的Size
 *
 *  @param fontSize 字体大小
 *  @param maxSize  文字的最大Size
 *
 *  @return 实际的Size
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize;

/**
 *  不限定大小的文字最大Size
 *
 *  @param font 字体大小
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize;

/**
 *  限定最大宽度的文字最大Size
 *
 *  @param fontSize 字体大小
 *  @param maxWidth 文字最大宽度
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;

@end
