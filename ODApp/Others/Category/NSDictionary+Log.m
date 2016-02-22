//
//  NSDictionary+Log.m
//  JSON获取视频
//
//  Created by heyode on 15/10/19.
//  Copyright © 2015年 heyode. All rights reserved.
//  自定义打印字典中文,只需拷贝这个文件到项目中即可

#import <Foundation/Foundation.h>


@implementation NSDictionary (Log)

// 使用%@打印字典时，会调用NSDictionary的descriptionWithLocale:方法
// 所以重写这个方法可以解决打印字典乱码的问题
/**
 要实现的样式
 [
 {
	id:16
	length:40
	image:resources/images/minion_16.png
	name:小黄人 第16部
	url:resources/videos/minion_16.mp4
 }
 ]
 
 */

- (NSString *)descriptionWithLocale:(id)locale{
    // 1.定义字符创保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"{\n"];
    
    // 2.遍历字典，拼接字典中的键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            obj = [NSString stringWithFormat:@"\"%@\"",obj];
        }
        [strM appendFormat:@"\t\"%@\":%@\n",key,obj];
    }];
    
    [strM appendFormat:@"}\n"];
    return strM;
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale{
    // 1.定义字符创保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"[\n"];
    
    // 2.遍历字典，拼接字典中的键值对
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@",obj];
    }];
    
    [strM appendFormat:@"]\n"];
    return strM;
}


@end
