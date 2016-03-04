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
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODAPPInfoTool.h"


@interface AppDelegate () <UIScrollViewDelegate, WXApiDelegate> {
    NSUncaughtExceptionHandler *_uncaughtExceptionHandler;
}

@property(nonatomic, strong) MyPageControl *pageControl;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIViewController *ViewController;
@property(nonatomic, assign) NSInteger length;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;


@end

@implementation AppDelegate

/**
 *  程序出bug,可以发送bug邮件
 */
#pragma mark - bug邮件

void UncaughtExceptionHandler(NSException *exception) {
    NSLog(@"----UncaughtExceptionHandler");
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRuned"] boolValue]) {
        //进入主界面
        [self gotoMain];
    } else {
        // 加载引导图
        [self makeLaunchView];
    }
    [ODAppRegister registJPushWithLaunchOption:launchOptions];
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

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
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


- (void)gotoMain {
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isRuned"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *openId = [user objectForKey:KUserDefaultsOpenId];
    [ODUserInformation sharedODUserInformation].openID = openId ? openId : @"";
    
    NSString *avatar = [user objectForKey:KUserDefaultsAvatar];
    [ODUserInformation sharedODUserInformation].avatar = avatar ? avatar : @"";
    
    NSString *mobile = [user objectForKey:KUserDefaultsMobile];
    [ODUserInformation sharedODUserInformation].avatar = mobile ? mobile : @"";
    
    
    self.window.rootViewController = [[ODTabBarController alloc] init];
    
    [ODAppRegister registIQKeyboardManager];
    
    [ODAppRegister registUMSocial];
}

- (void)makeLaunchView {
    
    
    self.ViewController = [[UIViewController alloc] init];
    self.ViewController.view.frame = [UIScreen mainScreen].bounds;
    
    
    
    // 数组内存放加载引导图片
    NSArray *arr = [NSArray arrayWithObjects:@"begin1.jpg", @"begin2.jpg", @"begin3.jpg", @"begin4.jpg", @"begin5.jpg", nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * arr.count, [UIScreen mainScreen].bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    //scrollerView指示条属性(默认是YES)
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    if (iPhone4_4S) {
        
        self.length = 200;
        
    } else if (iPhone5_5s) {
        
        self.length = 250;
        
        
    } else if (iPhone6_6s) {
        
        self.length = 300;
        
        
    } else {
        
        self.length = 330;
        
    }
    
    
    self.pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(self.ViewController.view.center.x - 50, self.ViewController.view.center.y * 2 - 30, 200, 30) normalImage:[UIImage imageNamed:@"selected.png"] highlightedImage:[UIImage imageNamed:@"noselected.png"] dotsNumber:4 sideLength:15 dotsGap:10];
    
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    
    [self.ViewController.view addSubview:self.scrollView];
    [self.ViewController.view addSubview:self.pageControl];
    
    
    self.window.rootViewController = self.ViewController;
    
    
    for (int i = 0; i < arr.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        if (i < arr.count - 1) {
            img.image = [UIImage imageNamed:arr[i]];
        } else {
            
            img.image = [UIImage imageNamed:arr[i]];
            img.userInteractionEnabled = YES;
            
            UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goButton.frame = CGRectMake(self.window.center.x - 70, self.window.center.y + 130, 140, 50);
            [goButton setTitle:@"立即体验" forState:UIControlStateNormal];
            goButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [goButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            goButton.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
            goButton.layer.masksToBounds = YES;
            goButton.layer.cornerRadius = 25;
            goButton.layer.borderColor = [UIColor blackColor].CGColor;
            goButton.layer.borderWidth = 1;
            
            
            [goButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:goButton];
            
            
        }
        
        [self.scrollView addSubview:img];
        
    }
    
}


- (void)tapAction:(UIButton *)sender {
    
    
    [UIView animateWithDuration:.5 animations:^{
        
        //让imageView 渐变消失
        self.scrollView.alpha = 0;
    }                completion:^(BOOL finished) {
        
        //将scrollView移除
        [self.scrollView removeFromSuperview];
        //进入主界面
        [self gotoMain];
    }];
    
    
}


//停止滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    // 拿到偏移量
    CGPoint offset = self.scrollView.contentOffset;
    
    // 算出偏移了几个fram.width
    NSInteger currentIndex = offset.x / self.scrollView.frame.size.width;
    
    
    if (currentIndex == 4) {
        
        self.pageControl.alpha = 0;
        
        
    } else {
        
        self.pageControl.alpha = 1;
        
        
        // 根据currentIndex 修改pageControl显示的点的位置
        self.pageControl.currentPage = currentIndex;
        
    }
    
    
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
