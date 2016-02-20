//
//  AppMethod.h
//  PNeayBy
//
//  Created by wpf on 15/11/15.
//  Copyright © 2015年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppMethod : NSObject

+ (AppMethod *)shared;
/**
 * 获取32为随机字符串
 */
+ (NSString *)getRandomString;
/**
 * 获取用户IP地址
 */
+ (NSString *)deviceIPAdress;
/**
 * 签名，并返回添加签名的完整字典
 */
+ (NSMutableDictionary *)partnerSignOrder:(NSDictionary*)paramDic;
/**
 * MD5 签名
 */
+ (NSString *)signString:(NSString*)origString;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com