//
//  ODRegisteredController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODRegisteredController.h"
#import "ODRegisteredView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODLandMainController.h"
@interface ODRegisteredController ()

@property(nonatomic , strong) UIView *headView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self navigationInit];
    [self createTimer];
    
    
     self.seePassWord = NO;
    
    
     self.currentTime = 60;
    
}


- (void)loadView
{
    [super loadView];
    self.view = self.registView;
}


#pragma mark - 初始化

-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 选择中心label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"账号注册" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
    
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
         self.registView.registereButton.layer.borderColor = [ODColorConversion colorWithHexString:@"#b0b0b0" alpha:1].CGColor;
         self.registView.registereButton.layer.borderWidth = 1;

        
        self.registView.password.secureTextEntry = YES;
        
                
        [self.registView.getVerification addTarget:self action:@selector(getVerification:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.registView.registereButton addTarget:self action:@selector(registere:) forControlEvents:UIControlEventTouchUpInside];
        
        
           [self.registView.seePassword addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _registView;
}

#pragma mark - 点击事件
- (void)registere:(UIButton *)sender
{
    
    [self getRegest];
    
}


- (void)getVerification:(UIButton *)sender
{
    
    
    [self getCode];
    
    
    
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
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 请求数据
-(void)getRegest
{
    
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"passwd":self.registView.password.text,@"verify_code":self.registView.verification.text};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/register";

    
    self.managers = [AFHTTPRequestOperationManager manager];
    
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
         
            ODLandMainController *vc = [[ODLandMainController alloc] init];
            NSMutableDictionary *dic = responseObject[@"result"];
            NSString *openId = dic[@"open_id"];
            
            [ODUserInformation getData].openID = openId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:responseObject[@"message"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定" , nil];
            [alter show];
        }

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        
        
    }];
}


-(void)getCode
{
    
    
    NSDictionary *parameters = @{@"mobile":self.registView.phoneNumber.text,@"type":@"1"};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/verify/code/send";

    
    
     self.manager = [AFHTTPRequestOperationManager manager];
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
   
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            //启动定时器
            [self.timer setFireDate:[NSDate distantPast]];        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:responseObject[@"message"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定" , nil];
            [alter show];
        }
        

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
     
       
        
    }];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
