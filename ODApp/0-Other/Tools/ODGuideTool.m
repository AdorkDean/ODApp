//
//  ODGuideTool.m
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODGuideTool.h"

#import "ODTabBarController.h"
#import "ODNewFeatureViewController.h"

#import "ODUserInformation.h"
#import "ODAppRegister.h"


@implementation ODGuideTool

+ (UIViewController *)chooseRootViewController
{
    // 读取旧的版本号
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsVersionKey];
    // 获取plist中的版本号
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *newVersion = infoDic[kUserDefaultsVersionKey];
    // 比较
    if ([oldVersion isEqualToString:newVersion])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *openId = [user objectForKey:KUserDefaultsOpenId];
        [ODUserInformation sharedODUserInformation].openID = openId ? openId : @"";
        
        NSString *avatar = [user objectForKey:KUserDefaultsAvatar];
        [ODUserInformation sharedODUserInformation].avatar = avatar ? avatar : @"";
        
        NSString *mobile = [user objectForKey:KUserDefaultsMobile];
        [ODUserInformation sharedODUserInformation].avatar = mobile ? mobile : @"";
        
        [ODAppRegister registIQKeyboardManager];
        
        [ODAppRegister registUMSocial];
        
        return [[ODTabBarController alloc] init];
    }
    else
    {
        // 保存版本号
        [[NSUserDefaults standardUserDefaults] setValue:newVersion forKeyPath:kUserDefaultsVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[ODNewFeatureViewController alloc] init];
    }
}
                            

@end
