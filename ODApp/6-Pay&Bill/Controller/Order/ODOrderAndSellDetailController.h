//
//  ODOrderDetailController.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODOrderAndSellDetailController : ODBaseViewController

@property(nonatomic, copy) NSString *order_id;

/**
 * 订单类型
 **/
@property(nonatomic, copy) NSString *orderType;

/**
 * 订单状态
 **/
@property(nonatomic, copy) NSString *orderStatus;

/**
 *
 **/
@property(nonatomic, copy) NSString *swapType;

/**
 * 刷新block
 **/
@property(nonatomic, copy) void(^getRefresh)(NSString *isRefresh);

/**
 * 选择卖出订单详情
 **/
@property(nonatomic, assign) BOOL isSellDetail;


@end
