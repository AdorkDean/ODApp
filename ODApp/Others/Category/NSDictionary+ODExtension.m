//
//  NSDictionary+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "NSDictionary+ODExtension.h"

@implementation NSDictionary (ODExtension)
- (void)NSLogProperty
{
    
    // 拼接属性字符串代码
    NSMutableString *strM = [NSMutableString string];
    @try {
        // 1.遍历字典，把字典中的所有key取出来，生成对应的属性代码
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            // 类型经常变，抽出来
            NSString *type = @"<#type#>";
            NSString *desc = @"<#decription#>";
            NSString *star = @"*";
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                type = @"NSString";
                desc = @"copy";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                type = @"NSArray";
                desc = @"strong";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                type = @"NSDictionary";
                desc = @"strong";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                type = @"int";
                desc = @"assign";
                star = @"";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
                type = @"Bool";
                desc = @"assign";
                star = @"";
            }
            // 属性字符串
            NSString *str = [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@%@;",desc,type,star,key];
            // 每生成属性字符串，就自动换行。
            [strM appendFormat:@"\n%@\n",str];
        }];
        
        // 把拼接好的字符串打印出来，就好了。
        NSLog(@"property == /n%@",strM);
    }
    @catch (NSException *exception) {
        NSLog(@"json数据异常");
    }
   
}

- (NSString *)descriptionWithLocale:(id)locale{
    // 1.定义字符创保存拼接结果
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"{"];
    
    // 2.遍历字典，拼接字典中的键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            obj = [NSString stringWithFormat:@"\"%@\"",obj];
        }
        [strM appendFormat:@"\t\"%@\":%@,",key,obj];
        
    }];
    [strM replaceCharactersInRange:NSMakeRange(strM.length - 1, 1) withString:@"}"];
//    [strM appendFormat:@""];
    return strM;
}


@end
