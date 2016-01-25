//
//  NSURL+ODExtension.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/25.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "NSURL+ODExtension.h"
#import <objc/message.h>
@implementation NSURL (ODExtension)

+ (void)load
{
    Method OD_URLWithStringMethod = class_getClassMethod(self, @selector(OD_URLWithString:));
    Method urlWithStringMethod = class_getClassMethod(self, @selector(URLWithString:));
    method_exchangeImplementations(OD_URLWithStringMethod, urlWithStringMethod);
}

+ (instancetype)OD_URLWithString:(NSString *)URLString
{
    NSString *string = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL OD_URLWithString:string];
}
@end
