//
//  AppDelegate.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "AppDelegate.h"
#import "ODTabBarController.h"
#import "IQKeyboardManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "MyPageControl.h"
@interface AppDelegate ()
{
    NSUncaughtExceptionHandler *    _uncaughtExceptionHandler;
}

@property (nonatomic , strong) MyPageControl *pageControl;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIViewController *ViewController;
@property (nonatomic , assign) NSInteger length;



@end

@implementation AppDelegate

/**
 *  程序出bug,可以发送bug邮件
 */
#pragma mark - bug邮件
void UncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"----UncaughtExceptionHandler");
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto:lpz191@icloud.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isRuned"] boolValue]) {
        
        //进入主界面
        [self gotoMain];
        
        
    }else {
        
        // 加载引导图
        [self makeLaunchView];
        
    }
    
    
    
    
    
    return YES;
}

- (void)gotoMain
{
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isRuned"];
    self.window.rootViewController = [[ODTabBarController alloc]init];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    
    [UMSocialData setAppKey:@"569dda54e0f55a994f0021cf"];
    
    [UMSocialWechatHandler setWXAppId:@"wxd25da104118aae2a" appSecret:@"5da1d304e3b05fe65e4c14deddfa56f1" url:@"http://www.umeng.com/social"];
    
}

- (void)makeLaunchView
{
    
    
    self.ViewController = [[UIViewController alloc] init];
    self.ViewController.view.frame = [UIScreen mainScreen].bounds;
    
    
    
    // 数组内存放加载引导图片
    NSArray *arr=[NSArray arrayWithObjects:@"begin1.jpg", @"begin2.jpg", @"begin3.jpg", @"begin4.jpg", @"begin5.jpg" , nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width * arr.count, [UIScreen mainScreen].bounds.size.height);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    
    //scrollerView指示条属性(默认是YES)
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    
    
    if (iPhone4_4S) {
        
        self.length = 200;
        
    } else if (iPhone5_5s) {
        
        self.length = 250;
        
        
    }else if (iPhone6_6s) {
        
        self.length = 300;
        
        
    }else {
        
        self.length = 350;
        
    }
    
    
    self.pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake( self.ViewController.view.center.x - 50,  self.ViewController.view.center.y + self.length, 200, 30) normalImage:[UIImage imageNamed:@"selected.png"] highlightedImage:[UIImage imageNamed:@"noselected.png"] dotsNumber:4 sideLength:15 dotsGap:10];
    self.pageControl.delegate = self;
    
    
    self.pageControl.backgroundColor = [UIColor clearColor];
    
    
    
    [self.ViewController.view addSubview:self.scrollView];
    [self.ViewController.view addSubview:self.pageControl];
    
    
    
    self.window.rootViewController =  self.ViewController;
    
    
    
    for (int i = 0; i < arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        if (i < arr.count - 1) {
            img.image=[UIImage imageNamed:arr[i]];
        }else{
            
            img.image=[UIImage imageNamed:arr[i]];
            UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.window.center.x - 70, self.window.center.y + 130, 140, 50)];
            [v1 setImage:[UIImage imageNamed:@"begin"]];
            img.userInteractionEnabled = YES;
            v1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [v1 addGestureRecognizer:tap];
            [img addSubview:v1];
            
        }
        
        [self.scrollView addSubview:img];
        
    }
    
}




- (void)tapAction:(UITapGestureRecognizer *)sender
{
    
    
    [UIView animateWithDuration:.5 animations:^{
        
        //让imageView 渐变消失
        self.scrollView.alpha = 0;
    }completion:^(BOOL finished) {
        
        //将scrollView移除
        [self.scrollView  removeFromSuperview];
        //进入主界面
        [self gotoMain];
    }];
    
    
}


//停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    // 拿到偏移量
    CGPoint offset = self.scrollView.contentOffset;
    
    // 算出偏移了几个fram.width
    NSInteger currentIndex = offset.x / self.scrollView.frame.size.width;
    
    
    if (currentIndex == 4) {
        
        self.pageControl.alpha = 0;
        
        
    }else{
        
        self.pageControl.alpha = 1;
        
        
        // 根据currentIndex 修改pageControl显示的点的位置
        self.pageControl.currentPage = currentIndex;
        
    }
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSSetUncaughtExceptionHandler(_uncaughtExceptionHandler);
}

@end
