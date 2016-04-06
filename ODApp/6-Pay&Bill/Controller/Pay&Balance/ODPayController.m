//
//  ODPayController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODPayController.h"
#import "ODPaySuccessController.h"
#import "ODPayModel.h"
#import "WXApiObject.h"
#import "AppMethod.h"
#import "XMLDictionary.h"
#import "CommonUtil.h"
#import "ODPaySuccessController.h"

@interface ODPayController ()

@property(nonatomic, strong) ODPayModel *model;
@property(nonatomic, strong) UILabel *orderNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;

@end

@implementation ODPayController

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPay:) name:ODNotificationPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay:) name:ODNotificationPayfail object:nil];
}

- (void)dealloc {
    NSLogFunc
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取数据
- (void)getWeiXinDataWithParam:(NSDictionary *)params {
    // 拼接参数
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinTradeNumber parameters:params modelClass:[ODPayModel class] success:^(id model)
     {
         weakSelf.model = [model result];
         [weakSelf payMoney];
//         [weakSelf.navigationController popViewControllerAnimated:YES];
     }
                   failure:^(NSError *error)
    {
     }];
}

- (void)getDatawithCode:(NSString *)code {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_no"] = self.model.out_trade_no;
    params[@"errCode"] = code;
    params[@"type"] = self.tradeType;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinCallbackSync parameters:params modelClass:[NSObject class] success:^(id model)
     {
         [weakSelf.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[ODPaySuccessController class]])
             {
                 [(ODPaySuccessController *)obj setPayStatus:weakSelf.isPay];
                 
                 if (idx != weakSelf.navigationController.childViewControllers.count - 1)
                 {
                     [weakSelf.navigationController popToViewController:obj animated:YES];
                 }
                 return ;
             }
             
         }];
         ODPaySuccessController *vc = [[ODPaySuccessController alloc] init];
         vc.swap_type = weakSelf.swap_type;
         vc.payStatus = weakSelf.isPay;
         vc.orderId = weakSelf.orderId;
         vc.params = weakSelf.successParams;
         vc.tradeType = weakSelf.tradeType;
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         [weakSelf.navigationController popViewControllerAnimated:YES]; 
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


@end
