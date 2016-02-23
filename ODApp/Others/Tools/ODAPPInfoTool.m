//
//  ODAPPInfoTool.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/23.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODAPPInfoTool.h"

@implementation ODAPPInfoTool

+ (NSString *)APPVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)APPBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (double)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}


@end
