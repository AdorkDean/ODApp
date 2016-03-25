//
//  NSString+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "NSString+ODExtension.h"

@implementation NSString (ODExtension)

- (BOOL)isBlank
{
    if (self.length == 0)
    {
        return true;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

/**
 *  限制文字的Size, 计算文字实际的Size
 *
 *  @param fontSize 字体大小
 *  @param maxSize  文字的最大Size
 *
 *  @return 实际的Size
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    // 字体大小
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                           attributes:attrs
                              context:nil].size;
}

/**
 *  不限定大小的文字最大Size
 *
 *  @param font 字体大小
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize
{
    return [self od_sizeWithFontSize:fontSize maxWidth:MAXFLOAT];
}

/**
 *  限定最大宽度的文字最大Size
 *
 *  @param fontSize 字体大小
 *  @param maxWidth 文字最大宽度
 */
- (CGSize)od_sizeWithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    return [self od_sizeWithFontSize:fontSize maxSize:CGSizeMake(maxWidth, MAXFLOAT)];
}

@end
