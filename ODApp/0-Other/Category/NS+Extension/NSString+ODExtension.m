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
 *  计算文字Size
 */
- (CGSize)od_SizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (CGSize)od_SizeWithFont:(UIFont *)font
{
    return [self od_SizeWithFont:font maxWidth:MAXFLOAT];
}

@end
