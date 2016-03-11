//
//  ODAPPInfoTool.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/23.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODAPPInfoTool : NSObject

/**
 *  获取Version版本号
 */
+ (NSString *)APPVersion;

/**
 *  获取Build版本号
 */
+ (NSString *)APPBuild;

/**
 *  获取 当前设备版本
 */
+ (double)iOSVersion;

@end
