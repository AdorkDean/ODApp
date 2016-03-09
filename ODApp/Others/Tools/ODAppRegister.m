//
//  ODAppRegister.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "MobClick.h"
#import "ODAPPInfoTool.h"
#import "ODAppRegister.h"
#import "IQKeyboardManager.h"
#import "MAMapKit.h"
#import "AMapSearchServices.h"


/** 微信的apiKey */
static NSString * const kGetWXAppId = @"wx64423cc9497cc581";
static NSString * const kGetWXAppSecret = @"a6034898f4a370df22a358c5e6192645";
/** 高德地图的apiKey */
static NSString * const ODLocationApiKey = @"82b3b9feaca8b2c33829a156672a5fd0";
/** 极光推送的apiKey */
static NSString * const JPushAppKey = @"0e65afefdb32078c64936a6b";
static NSString * const JPushMasterSecret = @"1d57142cfee45fd7bd0218cf";
static NSString * const channel = @"AppStore";
static BOOL const isProduction = FALSE;


@implementation ODAppRegister

+ (void)registWechat
{
    [WXApi registerApp:kGetWXAppId withDescription:@"我去App"];
}

+ (void)registStatistics
{
    [MobClick startWithAppkey:kGetUMAppkey reportPolicy:BATCH channelId:channel];
    [MobClick setAppVersion:[ODAPPInfoTool APPVersion]];
}

+ (void)registUMSocial
{
    [UMSocialData setAppKey:kGetUMAppkey];
    
    [UMSocialWechatHandler setWXAppId:kGetWXAppId appSecret:kGetWXAppSecret url:@"http://www.umeng.com/social"];
}

+ (void)registJPushWithLaunchOption:(NSDictionary *)launchOptions
{
    // Required
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        [JPUSHService registerForRemoteNotificationTypes:
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound |
         UIUserNotificationTypeAlert
                                              categories:nil];
    }
#endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:channel apsForProduction:isProduction];
}

+ (void)registGDMap
{
    //配置用户Key
    [MAMapServices sharedServices].apiKey = ODLocationApiKey;
    [AMapSearchServices sharedServices].apiKey = ODLocationApiKey;
}

+ (void)registIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

@end
