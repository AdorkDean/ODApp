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

@end
