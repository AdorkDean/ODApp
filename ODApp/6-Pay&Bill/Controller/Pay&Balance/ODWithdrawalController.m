//
//  ODWithdrawalController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODWithdrawalController.h"
#import "ODWithdrawalView.h"

@interface ODWithdrawalController () <UITextViewDelegate>

@property(nonatomic, strong) ODWithdrawalView *withdrawalView;

@end

@implementation ODWithdrawalController

#pragma mark - 懒加载
- (ODWithdrawalView *)withdrawalView {
    if (_withdrawalView == nil) {
        self.withdrawalView = [ODWithdrawalView getView];
        self.withdrawalView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        
        self.withdrawalView.prcieLabel.text = [NSString stringWithFormat:@"￥%@", self.price];
        self.withdrawalView.payAddressTextView.delegate = self;
        self.withdrawalView.withdrawalButton.enabled = ![self.price isEqualToString:@"0.00"];
        self.withdrawalView.withdrawalButton.backgroundColor = self.withdrawalView.withdrawalButton.enabled ? [UIColor colorRedColor] : [UIColor lightGrayColor];
        [self.withdrawalView.withdrawalButton addTarget:self action:@selector(withdrawalAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _withdrawalView;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.userInteractionEnabled = YES;

    [self.view addSubview:self.withdrawalView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 请求数据
- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = self.price;
    params[@"account"] = self.withdrawalView.payAddressTextView.text;
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserWithdrawCash parameters:params modelClass:[NSObject class] success:^(id model)
     {
         [weakSelf.navigationController popViewControllerAnimated:YES];
         
         [ODProgressHUD showInfoWithStatus:@"提现成功"];
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - UITextView 代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.withdrawalView.payAddressTextView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"] || [self.withdrawalView.payAddressTextView.text isEqualToString:@""]) {
        self.withdrawalView.payAddressTextView.text = @"请输入和注册手机一致的支付宝账号";
        self.withdrawalView.payAddressTextView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 事件方法
- (void)withdrawalAction:(UIButton *)sender {

    [self.view endEditing:YES];

    if ([self.withdrawalView.payAddressTextView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"] || [self.withdrawalView.payAddressTextView.text isEqualToString:@""]) {

        [ODProgressHUD showInfoWithStatus:@"请输入支付宝账号"];

    } else {
        [self getData];
    }
}

@end
