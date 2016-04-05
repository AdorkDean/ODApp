//
//  ODExchangePayViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayView.h"
#import "ODExchangePayViewController.h"

@interface ODExchangePayViewController ()
@property(nonatomic, strong) ODPayView *payView;

@end

@implementation ODExchangePayViewController

#pragma mark - 懒加载
- (ODPayView *)payView {
    if (_payView == nil) {
        self.payView = [ODPayView getView];
        self.payView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        
        [self.payView.weixinPaybutton addTarget:self action:@selector(weixinPayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.payView.treasurePayButton addTarget:self action:@selector(treasurePayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.payView.orderNameLabel.text = self.OrderTitle;
        self.payView.priceLabel.text = [NSString stringWithFormat:@"%.2f元", [self.price floatValue]];
        self.payView.priceLabel.textColor = [UIColor redColor];
        self.payView.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f元", [self.price floatValue]];
        [self.payView.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.payView];
    }
    return _payView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付订单";
    self.tradeType = @"0";
    [self payView];

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

- (void)payAction:(UIButton *)sender {
    if ([self.payType isEqualToString:@"1"]) {
        if ([WXApi isWXAppInstalled]) {
            if ([self.isPay isEqualToString:@"1"]) {
                [ODProgressHUD showInfoWithStatus:@"该订单已支付"];
            } else {
                self.successParams = @{
                                       @"bbs_order_id":self.orderId
                                       };
                
                [self getWeiXinDataWithParam:self.successParams];
            }
        }
        else {
            [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
        }
    }
    else {
        if ([self.isPay isEqualToString:@"1"]) {
            [ODProgressHUD showInfoWithStatus:@"该订单已支付"];
        }
        else {
            [ODProgressHUD showInfoWithStatus:@"支付宝支付暂未开放"];
        }
    }
}


@end
