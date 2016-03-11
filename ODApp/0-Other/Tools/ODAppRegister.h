//
//  ODAppRegister.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "WXApi.h"
#import "UMSocial.h"
#import "JPUSHService.h"
#import "UMSocialWechatHandler.h"
#import <Foundation/Foundation.h>

@interface ODAppRegister : NSObject

+ (void)registWechat;

+ (void)registStatistics;

+ (void)registUMSocial;

+ (void)registJPushWithLaunchOption:(NSDictionary *)launchOptions;

+ (void)registGDMap;

+ (void)registIQKeyboardManager;

@end
