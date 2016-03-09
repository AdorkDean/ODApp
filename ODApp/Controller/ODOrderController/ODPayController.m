//
//  ODPayController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODPayController.h"
#import "ODPayView.h"
#import "ODPaySuccessController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODPayModel.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AppMethod.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"
#import "CommonUtil.h"
#import "ODPaySuccessController.h"

@interface ODPayController ()

@property(nonatomic, strong) UILabel *orderNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) ODPayView *payView;
@property(nonatomic, copy) NSString *payType;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) ODPayModel *model;
@property(nonatomic, strong) AFHTTPRequestOperationManager *goManager;
@property(nonatomic, copy) NSString *isPay;
@property(nonatomic, assign) int navHasSelfClass;

@end

@implementation ODPayController

#pragma mark - 懒加载
- (ODPayView *)payView {
    if (_payView == nil) {
        self.payView = [ODPayView getView];
        self.payView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        
        
        [self.payView.weixinPaybutton addTarget:self action:@selector(weixinPayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.payView.treasurePayButton addTarget:self action:@selector(treasurePayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.payView.orderNameLabel.text = self.OrderTitle;
        self.payView.priceLabel.text = [NSString stringWithFormat:@"%@元", self.price];
        self.payView.priceLabel.textColor = [UIColor redColor];
        self.payView.orderPriceLabel.text = [NSString stringWithFormat:@"%@元", self.price];
        [self.payView.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _payView;
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

    self.payType = @"1";
    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.payView];
    [self getData];
    
    self.navHasSelfClass = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc class] == [ODPayController class]) {
            self.navHasSelfClass += 1;
        }
    }
    
    if (self.navHasSelfClass == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPay:) name:ODNotificationPaySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay:) name:ODNotificationPayfail object:nil];
    }



}
- (void)dealloc {
    if (self.navHasSelfClass == 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取数据
- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bbs_order_id"] = self.orderId;
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinTradeNumber parameters:params modelClass:[ODPayModel class] success:^(id model)
     {
         weakSelf.model = [model result];
     } failure:^(NSError *error) {
     }];
}
- (void)getDatawithCode:(NSString *)code {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_no"] = self.model.out_trade_no;
    params[@"errCode"] = code;
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinCallbackSync parameters:params modelClass:[NSObject class] success:^(id model)
     {
         ODPaySuccessController *vc = [[ODPaySuccessController alloc] init];
         vc.swap_type = weakSelf.swap_type;
         vc.payStatus = weakSelf.isPay;
         vc.orderId = weakSelf.orderId;

         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - 事件方法
- (void)failPay:(NSNotification *)text {


    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"2";
    [self getDatawithCode:code];


}

- (void)successPay:(NSNotification *)text {


    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"1";
    [self getDatawithCode:code];


}

- (void)payAction:(UIButton *)sender {

    if ([self.payType isEqualToString:@"1"]) {


        if ([WXApi isWXAppInstalled]) {

            if ([self.isPay isEqualToString:@"1"]) {


                [ODProgressHUD showInfoWithStatus:@"该订单已支付"];


            } else {

                [self payMoney];


            }

        } else {


            [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
        }


    } else {


        if ([self.isPay isEqualToString:@"1"]) {

            [ODProgressHUD showInfoWithStatus:@"该订单已支付"];


        } else {


            [ODProgressHUD showInfoWithStatus:@"支付宝支付暂未开放"];


        }


    }


}

- (void)payMoney {


    PayReq *request = [[PayReq alloc] init];

    request.partnerId = self.model.partnerid;

    request.prepayId = self.model.prepay_id;

    request.package = self.model.package;

    request.nonceStr = self.model.nonce_str;

    request.timeStamp = self.model.timeStamp;

    request.sign = self.model.sign;

    [WXApi sendReq:request];


}

- (void)weixinPayAction:(UIButton *)sender {

    self.payType = @"1";

    [self.payView.weixinPaybutton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];

    [self.payView.treasurePayButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];


}

- (void)treasurePayAction:(UIButton *)sender {
    self.payType = @"2";

    [self.payView.treasurePayButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];

    [self.payView.weixinPaybutton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];


}


@end
