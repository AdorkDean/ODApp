//
//  ODOrderDetailController.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODIndentDetailController : ODBaseViewController

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
 * 刷新block
 **/
@property(nonatomic, copy) void(^getRefresh)(NSString *isRefresh);

@end
