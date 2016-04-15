//
//  ODChangePassWordController.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODNavigationBarView.h"
#import "ODChangePassWordController.h"
#import "ODRegisteredView.h"



@interface ODChangePassWordController ()<UITextFieldDelegate>

@property(nonatomic , strong) ODRegisteredView *registView;
// 定时器
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)NSInteger currentTime;

@end

@implementation ODChangePassWordController

#pragma mark - 懒加载
/**
 *  懒加载定时器
 */
- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (ODRegisteredView *)registView
{
    if (_registView == nil) {
        
        self.registView = [ODRegisteredView getView];
        
        if ([self.topTitle isEqualToString:@"忘记密码"]) {
            self.registView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height);
        } else {
            self.registView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            
        }
        if ([self.topTitle isEqualToString:@"修改密码"]) {
            self.registView.phoneNumber.userInteractionEnabled = NO;
            ODUserModel *user = [[ODUserInformation sharedODUserInformation] getUserCache];
            self.registView.phoneNumber.text = user.mobile;
        }
        
        [self.registView.getVerification addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.registereButton addTarget:self action:@selector(registere:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.registereButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [self.registView.seePassword addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        self.registView.agreementButton.hidden = YES;
        self.registView.spaceConstraint.constant = 30;
        self.registView.phoneNumber.delegate = self;
        self.registView.password.delegate = self;
    }
    return _registView;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self.view addSubview:self.registView];
    self.currentTime = getVerificationCodeTime;
}

#pragma mark - 初始化方法
- (void)navigationInit
{
    if ([self.topTitle isEqualToString:@"忘记密码"]) {
        ODNavigationBarView *naviView = [ODNavigationBarView navigationBarView];
        naviView.title = @"忘记密码";
        naviView.leftBarButton = [ODBarButton barButtonWithTarget:self action:@selector(fanhui:) title:@"返回"];
        [self.view addSubview:naviView];
    }else {
        self.navigationItem.title = @"修改密码";
    }
}

#pragma mark - 请求数据
-(void)changePassWord
{
    __weakSelf
    NSDictionary *parameters = @{
                                 @"mobile":self.registView.phoneNumber.text,
                                 @"passwd":self.registView.password.text,
                                 @"verify_code":self.registView.verification.text
                                 };
    [ODHttpTool getWithURL:ODUrlUserChangePasswd parameters:parameters modelClass:[NSObject class] success:^(id model)
     {
         if ([weakSelf.topTitle isEqualToString:@"修改密码"]) {
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }else{
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
         }
     } failure:^(NSError *error) {
         
     }];
}
-(void)getCode
{
    __weakSelf;
    NSDictionary *parameters = @{ @"mobile":self.registView.phoneNumber.text, @"type":@"3" };
    [ODHttpTool getWithURL:ODUrlUserCodeSend parameters:parameters modelClass:[NSObject class] success:^(id model) {
        // 开启定时器
        [weakSelf timer];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 事件方法
-(void)timerClick
{
    self.currentTime -- ;
    if (self.currentTime == 0) {
        [self.registView.getVerification setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.registView.getVerification.userInteractionEnabled = YES;
        // 停止定时器
        [self.timer invalidate];
        self.timer = nil;
        self.currentTime = getVerificationCodeTime;
    }else{
        [self.registView.getVerification setTitle:[NSString stringWithFormat: @"%ld秒后重发",(long)self.currentTime] forState:UIControlStateNormal];
        self.registView.getVerification.userInteractionEnabled = NO;
    }
}

- (void)registere:(UIButton *)sender
{
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    [self.registView.password resignFirstResponder];
    
    if ([self.registView.phoneNumber.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入手机号"];
    }else if ([self.registView.verification.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入验证码"];
    }else if (self.registView.password.text.length < 6 || self.registView.password.text.length > 26 ) {
        [ODProgressHUD showToast:self.view msg:@"密码仅支持6到26位"];
    }else {
        [self changePassWord];
    }
}

- (void)getVerification:(UIButton *)sender
{
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.password resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    
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
    if ([self.topTitle isEqualToString:@"修改密码"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
