//
//  H5ToMobileRequest.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "PontoH5ToMobileRequest.h"
#import "ODTakeOutpaysingleModel.h"
#import "ODHttpTool.h"

#import "ODUserInformation.h"

#import "ODPersonalCenterViewController.h"
#import "ODConfirmOrderViewController.h"

#import "ODPayModel.h"
@implementation PontoH5ToMobileRequest {
}

+ (id)instance {
    
    return [[self alloc] init];
}

#pragma mark - 商品详情

// addToCart  H5 button点击事件
- (void)addToCart:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params------->%@",params[@"id"]);
        
        UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navVc = tabBarVc.selectedViewController;
        
        if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
            ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
            [navVc presentViewController:vc animated:YES completion:nil];
        } else {
            // 给购物车添加东西
            [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationShopCartAddNumber object:self];
        }
    }
}

#pragma mark - 订单详情

// paymentNow  H5 button点击事件
- (void)paymentNow:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params------->%@", params);
        [self getWeiXinData:params[@"id"]];
        [ODTakeOutPaySingleModel sharedODTakeOutPaySingleModel].order_no = params[@"order_no"];
    }
}

- (void)getWeiXinData:(NSString *)paramsId {
    
    if (![WXApi isWXAppInstalled]) {
        [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
        return;
    }
    self.successParam = @{
                          @"type" : @"1",
                          @"takeout_order_id" : [NSString stringWithFormat:@"%@", paramsId]
                          };
    [ODTakeOutPaySingleModel sharedODTakeOutPaySingleModel].params = self.successParam;
    [ODHttpTool getWithURL:ODUrlPayWeixinTradeNumber parameters:self.successParam modelClass:[ODPayModel class] success:^(id model) {
        
        ODPayModel *payModel = [model result];
        [self payMoneyGiveWeiXin:payModel];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)payMoneyGiveWeiXin:(ODPayModel *)model {
    PayReq *request = [[PayReq alloc] init];
    
    request.partnerId = model.partnerid;
    request.prepayId = model.prepay_id;
    request.package = model.package;
    request.nonceStr = model.nonce_str;
    request.timeStamp = model.timeStamp;
    request.sign = model.sign;
    
    [WXApi sendReq:request];
}


@end
