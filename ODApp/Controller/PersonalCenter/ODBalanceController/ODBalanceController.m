//
//  ODBalanceController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBalanceController.h"
#import "ODBalanceView.h"
#import "ODWithdrawalController.h"
#import "ODWithdrawalDetailController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODBalanceController ()

@property (nonatomic , strong) ODBalanceView *balanceView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic , copy) NSString *balance;

@end

@implementation ODBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.navigationItem.title = @"余额";
    self.view.userInteractionEnabled = YES;
  


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}


#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    NSDictionary *parameters = @{@"open_id":openId};
    
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kGetUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableDictionary *dic = responseObject[@"result"];
        
        weakSelf.balance = [NSString stringWithFormat:@"%@" , dic[@"balance"]];
        
        [self createView];
        
        
              
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


- (void)createView
{
    self.balanceView = [ODBalanceView getView];
    self.balanceView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    
    self.balanceView.balanceLabel.text = self.balance;
    
    [self.balanceView.withdrawalButton addTarget:self action:@selector(withdrawalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceView.withdrawalDetailButton addTarget:self action:@selector(withdrawalDetailAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:self.balanceView];
    
}


- (void)withdrawalAction:(UIButton *)sender
{
    
    ODWithdrawalController *vc = [[ODWithdrawalController alloc] init];
    vc.price = self.balance;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)withdrawalDetailAction:(UIButton *)sender
{
    ODWithdrawalDetailController *vc = [[ODWithdrawalDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
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
