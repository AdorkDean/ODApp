//
//  ODRegisteredController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODNavigationBarView.h"
#import "ODRegisteredController.h"
#import "ODRegisteredView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODLandMainController.h"


@interface ODRegisteredController ()<UITextFieldDelegate>

@property(nonatomic , strong) ODRegisteredView *registView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
//定时器
@property(nonatomic,strong)NSTimer *timer;
//当前秒数
@property(nonatomic)NSInteger currentTime;

@property (nonatomic , assign) BOOL seePassWord;

@end

@implementation ODRegisteredController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self createTimer];
    self.seePassWord = NO;
    self.currentTime = 60;
}


- (void)loadView
{
    self.view = self.registView;
}


#pragma mark - 初始化
- (void)navigationInit
{
    ODNavigationBarView *naviView = [ODNavigationBarView navigationBarView];
    naviView.title = @"账号注册";
    [naviView.leftBarButton setTarget:self action:@selector(fanhui:) title:@"返回"];
    naviView.rightBarButton = nil;
    [self.view addSubview:naviView];
}

-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    //先关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 定时器
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

#pragma mark - 懒加载
- (ODRegisteredView *)registView
{
    if (_registView == nil) {
        
        self.registView = [ODRegisteredView getView];
        
        self.registView.registereButton.layer.masksToBounds = YES;
        self.registView.registereButton.layer.cornerRadius = 5;
        self.registView.registereButton.layer.borderColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1].CGColor;
        self.registView.registereButton.layer.borderWidth = 1;
        
        self.registView.password.secureTextEntry = YES;
        
        [self.registView.getVerification addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.registView.registereButton addTarget:self action:@selector(registere:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.registView.seePassword addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
       
        self.registView.phoneNumber.delegate = self;
        self.registView.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
     
    }
    return _registView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.registView.phoneNumber) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 点击事件
- (void)registere:(UIButton *)sender
{
    
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    [self.registView.password resignFirstResponder];
    
    if ([self.registView.phoneNumber.text isEqualToString:@""]) {

        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入手机号"];
        
    }else if ([self.registView.verification.text isEqualToString:@""]) {
        
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入验证码"];
    }else if ([self.registView.password.text isEqualToString:@""]) {

        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入密码"];
    }

    else {
          [self getRegest];
    }
   
}


- (void)getVerification:(UIButton *)sender
{
    
    [self.registView.phoneNumber resignFirstResponder];
    [self.registView.verification resignFirstResponder];
    [self.registView.password resignFirstResponder];

    
    if ([self.registView.phoneNumber.text isEqualToString:@""]) {
        

        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入手机号"];
    }else {
        
        [self getCode];

    }
   
}

- (void)seePassword:(UIButton *)sender
{
    
    if (!self.seePassWord) {
        self.registView.password.secureTextEntry = NO;
        [self.registView.seePassword setImage:[UIImage imageNamed:@"xianshimima"] forState:UIControlStateNormal];
        
    }else{
        self.registView.password.secureTextEntry = YES;
        
        [self.registView.seePassword setImage:[UIImage imageNamed:@"yincangmima"] forState:UIControlStateNormal];
        
    }
    self.seePassWord = !self.seePassWord;
    
}


-(void)fanhui:(UIButton *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 请求数据
-(void)getRegest
{
  
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"passwd":self.registView.password.text,@"verify_code":self.registView.verification.text};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/register";

    self.managers = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
         
            ODLandMainController *vc = [[ODLandMainController alloc] init];
            NSMutableDictionary *dic = responseObject[@"result"];
            NSString *openId = dic[@"open_id"];
            
            [ODUserInformation sharedODUserInformation].openID = openId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            
            if (weakSelf.registView.password.text.length < 6 || weakSelf.registView.password.text.length > 26 ) {

                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"密码仅支持6到26位"];
                
            }else {

                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
            }
    
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


-(void)getCode
{
        
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"type":@"1"};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/verify/code/send";
   
    self.manager = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            //启动定时器
            [weakSelf.timer setFireDate:[NSDate distantPast]];        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
