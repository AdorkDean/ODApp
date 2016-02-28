//
//  ODPersonalCenterViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
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

@interface ODPersonalCenterViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ODlandingView *landView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , assign) NSInteger pageNumber;


@end

@implementation ODPersonalCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    self.pageNumber = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];;
    


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ODNavigationController *navi = self.presentingViewController.childViewControllers.lastObject;
    if (navi.childViewControllers.count == 2)
    {
        [navi popToRootViewControllerAnimated:YES];
    }
}

- (void)loadView
{
   
    self.view = self.landView;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pageNumber = 0;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.landView;
    [self.view addSubview:self.tableView];
    
}

- (void)navigationInit
{
    ODNavigationBarView *naviView = [ODNavigationBarView navigationBarView];
    naviView.title = @"登陆";
    naviView.leftBarButton = [ODBarButton barButtonWithTarget:self action:@selector(backAction:) title:@"返回"];
    naviView.rightBarButton = [ODBarButton barButtonWithTarget:self action:@selector(registered:) title:@"注册"];;
    [self.view addSubview:naviView];
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
        
        
       
        
        
        
        
        [ODProgressHUD showInfoWithStatus:@"请输入手机号"];

        
    }else if ([self.landView.passwordTextField.text isEqualToString:@""]) {
        
           [ODProgressHUD showInfoWithStatus:@"请输入密码"];
    }
    
    else {
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
    NSDictionary *parameters = @{@"mobile":self.landView.accountTextField.text,@"passwd":self.landView.passwordTextField.text};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
      self.manager = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kLoginUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];

            weakSelf.landView.accountTextField.text = @"";
            weakSelf.landView.passwordTextField.text = @"";
            
            
            NSMutableDictionary *dic = responseObject[@"result"];
            
            
            
            
            
            NSString *openId = dic[@"open_id"];
            NSString *avatar = dic[@"avatar"];
            NSString *mobile = dic[@"mobile"];
            
            [ODUserInformation sharedODUserInformation].openID = openId;
            [ODUserInformation sharedODUserInformation].mobile = mobile;

            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:openId forKey:KUserDefaultsOpenId];
            [user setObject:avatar forKey:KUserDefaultsAvatar];
            [user setObject:mobile forKey:KUserDefaultsMobile];
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                ODTabBarController *tabBar = (ODTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                tabBar.selectedIndex = tabBar.currentIndex;
                [weakSelf.delegate personalHasLoginSuccess];
            }];

         
           [ODProgressHUD showInfoWithStatus:@"登录成功"];
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            
            weakSelf.pageNumber++;
            if (weakSelf.pageNumber >= 3) {
                
             
                
             
                  [ODProgressHUD showInfoWithStatus:@"您的账号或者密码已多次输入错误，请找回密码或者重新注册"];
                
                
                
            }else {
                
                                
                
             
                    [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
                

                
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
