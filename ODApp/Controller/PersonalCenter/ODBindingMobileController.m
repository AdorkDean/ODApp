//
//  ODBindingMobileController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBindingMobileController.h"
#import "ODBindingMobileView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
@interface ODBindingMobileController ()

@property (nonatomic , strong) ODBindingMobileView *bindMobileView;
@property (nonatomic , strong) UIView *headView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
//定时器
@property(nonatomic, strong)NSTimer *timer;
//当前秒数
@property(nonatomic , assign)NSInteger currentTime;

@property(nonatomic , copy) NSString *openId;

@end

@implementation ODBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
      [self navigationInit];
    
    [self.view addSubview:self.bindMobileView];
    
    [self createTimer];
    
    
    self.currentTime = 60;

     self.openId = [ODUserInformation sharedODUserInformation].openID;
    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    
    UILabel *centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"绑定手机" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:centerNameLabe];
    
    
    
    // 返回button

    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:backButton];
    
}

-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    //先关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

//创建警告框
-(void)createUIAlertControllerWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 定时器
-(void)timerClick
{
    self.currentTime -- ;
    if (self.currentTime == 0) {
        [self.bindMobileView.getCodelButton setTitle:@"获取验证码" forState:UIControlStateNormal];
       self.bindMobileView.getCodelButton.userInteractionEnabled = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.currentTime = 60;
    }else{
        [self.bindMobileView.getCodelButton setTitle:[NSString stringWithFormat: @"%ld秒后重发",(long)self.currentTime] forState:UIControlStateNormal];
        self.bindMobileView.getCodelButton.userInteractionEnabled = NO;
    }
}


#pragma mark - 懒加载
- (ODBindingMobileView *)bindMobileView
{
    if (_bindMobileView == nil) {
        self.bindMobileView = [ODBindingMobileView getView];
        
        self.bindMobileView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height);
        
        
        [self.bindMobileView.getCodelButton addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bindMobileView.bindingButton addTarget:self action:@selector(bindingAction:) forControlEvents:UIControlEventTouchUpInside];

        
        
    }
    return _bindMobileView;
}

#pragma mark - 点击事件
- (void)getCodeAction:(UIButton *)sender
{
    
    
    [self getCodes];

}

- (void)bindingAction:(UIButton *)sender
{
    
    [self bingdingPhone];
    
}


-(void)fanhui:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 请求数据

-(void)getCodes
{
    
    NSDictionary *parameters = @{@"mobile":self.bindMobileView.phoneTextField.text,@"type":@"4" , @"open_id":self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/verify/code/send";
    
     self.manager = [AFHTTPRequestOperationManager manager];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            
            
            //启动定时器
            [weakSelf.timer setFireDate:[NSDate distantPast]];
        }else if (responseObject[@"error"]){
            
      
        }  else if ([responseObject[@"status"]isEqualToString:@"error"]){
            
            
            [weakSelf createUIAlertControllerWithTitle:responseObject[@"message"]];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];
}



-(void)bingdingPhone
{
    NSDictionary *parameters = @{@"mobile":self.bindMobileView.phoneTextField.text,@"verify_code":self.bindMobileView.verificationTextField.text , @"open_id":self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/bind/mobile";

    
    
    self.managers = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                weakSelf.getTextBlock(self.bindMobileView.phoneTextField.text);
            }
            
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            
            [weakSelf createUIAlertControllerWithTitle:responseObject[@"message"]];
       
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
