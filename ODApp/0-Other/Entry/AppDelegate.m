//
//  AppDelegate.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "AppDelegate.h"
#import "ODAppRegister.h"
#import "ODUserInformation.h"

#import "ODTabBarController.h"
#import "MyPageControl.h"
#import "WXApiObject.h"
#import "ODAPPInfoTool.h"

#import "ODGuideTool.h"


@interface AppDelegate () <UIScrollViewDelegate, WXApiDelegate> {
    NSUncaughtExceptionHandler *_uncaughtExceptionHandler;
}

@property(nonatomic, strong) MyPageControl *pageControl;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIViewController *ViewController;


@end

@implementation AppDelegate

/**
 *  程序出bug,可以发送bug邮件
 */
#pragma mark - bug邮件

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];

    NSString *urlStr = [NSString stringWithFormat:@"mailto:lpz191@icloud.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                                                          "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                                                  name, reason, [arr componentsJoinedByString:@"<br>"]];

    NSURL *url = [NSURL OD_URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [ODAppRegister registStatistics];
    [ODAppRegister registGDMap];
    [ODAppRegister registWechat];
    
    _uncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    // 根据需求选择根控制器
    self.window.rootViewController = [ODGuideTool chooseRootViewController];
    
    [ODAppRegister registIQKeyboardManager];
    
    [ODAppRegister registUMSocial];
    
    [ODAppRegister registJPushWithLaunchOption:launchOptions];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *openId = [user objectForKey:KUserDefaultsOpenId];
    [ODUserInformation sharedODUserInformation].openID = openId ? openId : @"";
    
    NSString *avatar = [user objectForKey:KUserDefaultsAvatar];
    [ODUserInformation sharedODUserInformation].avatar = avatar ? avatar : @"";
    
    NSString *mobile = [user objectForKey:KUserDefaultsMobile];
    [ODUserInformation sharedODUserInformation].avatar = mobile ? mobile : @"";

    
    return YES;
    
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *urlstring = [url absoluteString];

    if ([urlstring containsString:@"wx64423cc9497cc581://platformId=wechat"]) {
        BOOL result = [UMSocialSnsService handleOpenURL:url];
        if (result == FALSE) {
            //调用其他SDK，例如支付宝SDK等
        }
        return result;

    } else if ([urlstring containsString:@"wx64423cc9497cc581://pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return NO;
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSSetUncaughtExceptionHandler(_uncaughtExceptionHandler);
}

- (void)onResp:(BaseResp *)resp {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess: {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                NSString *code = [NSString stringWithFormat:@"%d", resp.errCode];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:code, @"codeStatus", nil];
                //创建通知
                NSNotification *notification = [NSNotification notificationWithName:ODNotificationPaySuccess object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                break;
            }
            default: {
                NSString *code = [NSString stringWithFormat:@"%d", resp.errCode];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:code, @"codeStatus", nil];
                //创建通知
                NSNotification *notification = [NSNotification notificationWithName:ODNotificationPayfail object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}

@end
