//
//  ODPersonalCenterViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODPersonalCenterViewController.h"
#import "ODTabBarController.h"
#import "ODHomeFoundViewController.h"
#import "ODlandingView.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "ODRegisteredController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODLandMainController.h"
#import "ODTabBarController.h"
#import "ODChangePassWordController.h"

@interface ODPersonalCenterViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ODlandingView *landView;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , assign) NSInteger pageNumber;


@end

@implementation ODPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self navigationInit];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    
    
    
}


-(void)loadView
{
    
    self.view = self.landView;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pageNumber = 0;
}


#pragma mark - 初始化


-(void)navigationInit
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 登陆label
    UILabel *centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"登陆" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:centerNameLabe];
    
    // 注册button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 60, 16,50, 44) target:self sel:@selector(registered:) tag:0 image:nil title:@"注册" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
    
    // 返回button
    
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backAction:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    [self.headView addSubview:backButton];
    
}


- (void)createTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.landView;
    [self.view addSubview:self.tableView];
    
}

//创建警告框
-(void)createUIAlertControllerWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 懒加载
- (ODlandingView *)landView
{
    if (_landView == nil) {
        self.landView = [ODlandingView getView];
        self.landView.userInteractionEnabled = YES;
        self.landView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        
        self.landView.accountLabel.layer.masksToBounds = YES;
        self.landView.accountLabel.layer.cornerRadius = 20;
        self.landView.accountLabel.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
        self.landView.accountLabel.layer.borderWidth = 1;
        
        self.landView.passwordLabel.layer.masksToBounds = YES;
        self.landView.passwordLabel.layer.cornerRadius = 20;
        self.landView.passwordLabel.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
        self.landView.passwordLabel.layer.borderWidth = 1;
        
        self.landView.landButton.layer.masksToBounds = YES;
        self.landView.landButton.layer.cornerRadius = 20;
        self.landView.landButton.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
        self.landView.landButton.layer.borderWidth = 1;
        self.landView.landButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
        [self.landView.landButton addTarget:self action:@selector(landAction:) forControlEvents:UIControlEventTouchUpInside];
        self.landView.passwordTextField.secureTextEntry = YES;
        
        [self.landView.forgetPassWordButton addTarget:self action:@selector(forgetPassawordAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _landView;
}

#pragma mark - 点击事件

- (void)backAction:(UIButton *)sender
{
    ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.selectedIndex = tabBar.currentIndex;
    
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
        
        [self createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"请输入手机号"];
        
    }else if ([self.landView.passwordTextField.text isEqualToString:@""]) {
        
        [self createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"请输入密码"];
    }
    
    else {
        [self landToView];
    }
    
}

- (void)registered:(UIButton *)sender
{
    ODRegisteredController *vc = [[ODRegisteredController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 请求数据
-(void)landToView
{
    NSDictionary *parameters = @{@"mobile":self.landView.accountTextField.text,@"passwd":self.landView.passwordTextField.text};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/login1";
    
    self.manager = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];

            weakSelf.landView.accountTextField.text = @"";
            weakSelf.landView.passwordTextField.text = @"";
            
            
            NSMutableDictionary *dic = responseObject[@"result"];
            NSString *openId = dic[@"open_id"];
            
            [ODUserInformation sharedODUserInformation].openID = openId;
            
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:openId forKey:KUserDefaultsOpenId];
            
            ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBar.selectedIndex = tabBar.currentIndex;
            

            ODHomeFoundViewController *vc1 = [[ODHomeFoundViewController alloc] init];
            
            [weakSelf.navigationController presentViewController:vc1 animated:YES completion:nil];
            [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:1.0f title:@"登陆成功"];
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            
            weakSelf.pageNumber++;
            if (weakSelf.pageNumber >= 3) {
                
                [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:1.0f title:@"您的账号或者密码已多次输入错误，请找回密码或者重新注册"];
                
            }else {
                
                
                [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:1.0f title:responseObject[@"message"]];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}


#pragma mark - UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
