//
//  NSArray+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "NSArray+ODExtension.h"

@implementation NSArray (ODExtension)

- (NSString *)enumerateString
{
    NSMutableString *strM = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@",obj];
        if (idx != self.count - 1)
        {
            [strM appendString:@","];
        }
    }];
    return strM;
}

- (NSString *)od_desc
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
- (NSString *)od_URLDesc
{
    NSString *urlString = [self enumerateString];
    urlString = [@"["stringByAppendingString:urlString];
    urlString = [urlString stringByAppendingString:@"]"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return urlString;
}

- (NSString *)descriptionWithLocale:(id)locale
{
    return [self od_desc];
}

@end
