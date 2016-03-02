//
//  ODPersonalCenterViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODNavigationBarView.h"
#import "ODNavigationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODTabBarController.h"
#import "ODHomeFoundViewController.h"
#import "ODlandingView.h"
#import "ODRegisteredController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODLandMainController.h"
#import "ODTabBarController.h"
#import "ODChangePassWordController.h"
#import "ODUserResponse.h"



@interface ODPersonalCenterViewController ()

@property (nonatomic , strong) ODlandingView *landView;

@end



@implementation ODPersonalCenterViewController


#pragma mark - 界面
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self.view addSubview:self.landView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7" alpha:1];;
}

- (void)navigationInit
{
    ODNavigationBarView *naviView = [ODNavigationBarView navigationBarView];
    naviView.title = @"登录";
    naviView.leftBarButton = [ODBarButton barButtonWithTarget:self action:@selector(backAction:) title:@"返回"];
    naviView.rightBarButton = [ODBarButton barButtonWithTarget:self action:@selector(registered:) title:@"注册"];;
    [self.view addSubview:naviView];
}


- (ODlandingView *)landView
{
    if (_landView == nil) {
        self.landView = [ODlandingView getView];
        self.landView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height);
        [self.landView.landButton addTarget:self action:@selector(landAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.landView.forgetPassWordButton addTarget:self action:@selector(forgetPassawordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _landView;
}

#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    self.tabBarController.selectedIndex = ((ODTabBarController *)self.tabBarController).currentIndex;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)forgetPassawordAction:(UIButton *)sender
{
    ODChangePassWordController *vc = [[ODChangePassWordController alloc] init];
    vc.topTitle = @"忘记密码";
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)landAction:(UIButton *)sender
{
    
    [self.landView.accountTextField resignFirstResponder];
    [self.landView.passwordTextField resignFirstResponder];
    if ([self.landView.accountTextField.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入手机号"];
    } else if ([self.landView.passwordTextField.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入密码"];
    } else {
        [self landToView];
    }
    
}

- (void)registered:(UIButton *)sender
{
    ODRegisteredController *vc = [[ODRegisteredController alloc] init];
    vc.personalVC = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 请求数据
-(void)landToView
{
    NSDictionary *parameters = @{ @"mobile":self.landView.accountTextField.text, @"passwd":self.landView.passwordTextField.text};
    
    [ODAPIManager getWithURL:@"/user/login1" params:parameters success:^(id responseObject) {
        
        ODUserResponse *resp = [ODUserResponse mj_objectWithKeyValues:responseObject];
        ODUser *user = resp.result;
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
        [ODProgressHUD showToast:self.view msg:@"登录成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBar.selectedIndex = tabBar.currentIndex;
            if (self.delegate != nil) {
                [self.delegate personalHasLoginSuccess];
            }
        }];
        
    } error:^(NSString *msg) {
        [ODProgressHUD showToast:self.view msg:msg];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - umeng

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 内存管理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
