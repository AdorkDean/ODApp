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
#import "ODHomeFindViewController.h"
#import "ODlandingView.h"
#import "ODRegisteredController.h"
//#import "ODLandMainController.h"
#import "ODTabBarController.h"
#import "ODChangePassWordController.h"
#import "ODUserModel.h"

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
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#f7f7f7" alpha:1];;
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
    ODNavigationController *nav = [[ODNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - 请求数据
-(void)landToView
{
    __weakSelf
    NSDictionary *parameters = @{ @"mobile":self.landView.accountTextField.text, @"passwd":self.landView.passwordTextField.text};
    [ODHttpTool getWithURL:ODUrlUserLogin1 parameters:parameters modelClass:[ODUserModel class] success:^(id model)
    {
        ODUserModel *user = [model result];
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
        [ODProgressHUD showToast:self.view msg:@"登录成功"];
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBar.selectedIndex = tabBar.currentIndex;
            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationloveSkill object:nil];
            if (weakSelf.delegate != nil) {
                [weakSelf.delegate personalHasLoginSuccess];
            }
        }];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - umeng

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 解决键盘退出慢的问题
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

@end
