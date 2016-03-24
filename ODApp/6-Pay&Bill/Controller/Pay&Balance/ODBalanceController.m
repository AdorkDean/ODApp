//
//  ODBalanceController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBalanceController.h"
#import "ODBalanceView.h"
#import "ODWithdrawalController.h"
#import "ODWithdrawalDetailController.h"

@interface ODBalanceController ()

@property(nonatomic, strong) ODBalanceView *balanceView;
@property(nonatomic, copy) NSString *balance;

@end

@implementation ODBalanceController

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.navigationItem.title = @"余额";
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    self.view.userInteractionEnabled = YES;


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


#pragma mark - 请求数据

- (void)getData
{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserInfo parameters:@{} modelClass:[ODUserModel class] success:^(id model)
    {
        weakSelf.balance = [NSString stringWithFormat:@"%@",[[model result]balance]];
        
        [self createView];

    } failure:^(NSError *error) {
        
    }];
}


- (void)createView {
    self.balanceView = [ODBalanceView getView];
    self.balanceView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);

    self.balanceView.balanceLabel.text = self.balance;

    self.balanceView.balanceLabel.text = [NSString stringWithFormat:@"￥%@", self.balance];


    [self.balanceView.withdrawalButton addTarget:self action:@selector(withdrawalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceView.withdrawalDetailButton addTarget:self action:@selector(withdrawalDetailAction:) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:self.balanceView];

}


- (void)withdrawalAction:(UIButton *)sender {

    ODWithdrawalController *vc = [[ODWithdrawalController alloc] init];


    vc.price = self.balance;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)withdrawalDetailAction:(UIButton *)sender {
    ODWithdrawalDetailController *vc = [[ODWithdrawalDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
