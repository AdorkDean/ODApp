//
//  ODRegisteredController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODNavigationBarView.h"
#import "ODRegisteredController.h"
#import "ODRegisteredView.h"
#import "ODLandMainController.h"
#import  "ODTabBarController.h"
#import "ODHomeFoundViewController.h"
#import "ODUserModel.h"




@interface ODRegisteredController ()<UITextFieldDelegate>

// 视图
@property(nonatomic , strong) ODRegisteredView *registView;
//　定时器相关
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)NSInteger currentTime;

@end




@implementation ODRegisteredController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.registView];
    [self navigationInit];
    [self createTimer];
    self.currentTime = 60;
}

#pragma mark - 界面

- (ODRegisteredView *)registView
{
    if (_registView == nil) {
        self.registView = [ODRegisteredView getView];
        self.registView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height);
        [self.registView.getVerification addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.registereButton addTarget:self action:@selector(registere:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.seePassword addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        self.registView.phoneNumber.delegate = self;
        self.registView.password.delegate = self;
    }
    return _registView;
}

- (void)navigationInit
{
    ODNavigationBarView *naviView = [ODNavigationBarView navigationBarView];
    naviView.title = @"账号注册";
    naviView.leftBarButton = [ODBarButton barButtonWithTarget:self action:@selector(fanhui:) title:@"返回"];
    [self.view addSubview:naviView];
}


#pragma mark - 定时器
-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    //先关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)timerClick
{
    self.currentTime -- ;
    if (self.currentTime == 0) {
        [self.registView.getVerification setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.registView.getVerification.userInteractionEnabled = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.currentTime = 60;
    }else{
        [self.registView.getVerification setTitle:[NSString stringWithFormat: @"%ld秒后重发",(long)self.currentTime] forState:UIControlStateNormal];
        self.registView.getVerification.userInteractionEnabled = NO;
    }
}



#pragma mark - 点击事件

- (void)registere:(UIButton *)sender
{
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    [self.registView.password resignFirstResponder];
    
    if ([self.registView.phoneNumber.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入手机号"];
    } else if ([self.registView.verification.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入验证码"];
    } else if (self.registView.password.text.length < 6 || self.registView.password.text.length > 26) {
        [ODProgressHUD showToast:self.view msg:@"密码仅支持6到26位"];
    } else {
        [self getRegest];
        
    }
}


- (void)getVerification:(UIButton *)sender
{
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    [self.registView.password resignFirstResponder];
    
    if ([self.registView.phoneNumber.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入手机号"];
    }else {
        [self getCode];
    }
   
}

- (void)seePassword:(UIButton *)sender
{
    if (self.registView.password.secureTextEntry == YES) {
        [self.registView.seePassword setImage:[UIImage imageNamed:@"xianshimima"] forState:UIControlStateNormal];
        self.registView.password.secureTextEntry = NO;
    } else {
        [self.registView.seePassword setImage:[UIImage imageNamed:@"yincangmima"] forState:UIControlStateNormal];
        self.registView.password.secureTextEntry = YES;
    }
}


-(void)fanhui:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 请求数据
-(void)getRegest
{
    NSDictionary *params = @{
                             @"mobile":self.registView.phoneNumber.text,
                             @"passwd":self.registView.password.text,
                             @"verify_code":self.registView.verification.text
                             };
    [ODHttpTool getWithURL:ODUrlUserRegist parameters:params modelClass:[ODUserModel class] success:^(id model)
     {
        ODUserModel *user = [model result];
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBar.selectedIndex = tabBar.currentIndex;
        }];
        [ODProgressHUD showToast:self.view msg:@"注册成功"];
    }
                   failure:^(NSError *error)
    {
    
    }];
}


-(void)getCode
{
    NSDictionary *parameters = @{ @"mobile":self.registView.phoneNumber.text, @"type":@"1" };
    [ODHttpTool getWithURL:ODUrlUserCodeSend parameters:parameters modelClass:[NSObject class] success:^(id model)
     {
        
        [self.timer setFireDate:[NSDate distantPast]];
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 内存管理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - umeng
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
