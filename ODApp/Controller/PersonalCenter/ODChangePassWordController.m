//
//  ODChangePassWordController.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationBarView.h"
#import "ODChangePassWordController.h"
#import "ODRegisteredView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"


@interface ODChangePassWordController ()<UITextFieldDelegate>
@property(nonatomic , strong) ODRegisteredView *registView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;

//定时器
@property(nonatomic,strong)NSTimer *timer;
//当前秒数
@property(nonatomic)NSInteger currentTime;

@property (nonatomic , assign) BOOL seePassWord;

@end

@implementation ODChangePassWordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self.view addSubview:self.registView];
    [self createTimer];
    self.seePassWord = NO;
    self.currentTime = 60;
}


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

-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    //先关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}


#pragma mark - 定时器事件
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
        
        if ([self.topTitle isEqualToString:@"忘记密码"]) {
              self.registView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height);
        }else {
            self.registView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);

        }
        if ([self.topTitle isEqualToString:@"修改密码"]) {
            self.registView.phoneNumber.userInteractionEnabled = NO;
            self.registView.phoneNumber.text = self.phoneNumber;
            self.registView.phoneNumber.textColor = [UIColor lightGrayColor];
        }
        
        [self.registView.getVerification addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.registereButton addTarget:self action:@selector(registere:) forControlEvents:UIControlEventTouchUpInside];
        [self.registView.registereButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [self.registView.seePassword addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.registView.phoneNumber.delegate = self;
       
   
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
    if ([self.topTitle isEqualToString:@"修改密码"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - 请求数据
-(void)changePassWord
{
    
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"passwd":self.registView.password.text,@"verify_code":self.registView.verification.text};
    
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/change/passwd";
    
    self.managers = [AFHTTPRequestOperationManager manager];
    
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            
         
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
    
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"type":@"3"};
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
