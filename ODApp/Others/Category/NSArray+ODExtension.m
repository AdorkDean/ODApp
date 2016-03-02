//
//  NSArray+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "NSArray+ODExtension.h"

@implementation NSArray (ODExtension)

- (NSString *)description
{
    // 1.定义字符创保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"[\n"];
    
    // 2.遍历字典，拼接字典中的键值对
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@",obj];
        if (idx != self.count - 1)
        {
            [strM appendString:@",\n"];
        }
    }];
    
    [strM appendFormat:@"]\n"];
    
    return strM;

}

- (NSString *)desc
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"[\n"];
    
    // 2.遍历字典，拼接字典中的键值对
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@",obj];
        if (idx != self.count - 1)
        {
            [strM appendString:@",\n"];
        }
    }];
    
    [strM appendFormat:@"]\n"];
    
    return strM;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    return [self description];
}

@end
