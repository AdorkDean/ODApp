//
//  ODMyOrderDetailController.h
//  ODApp
//
//  Created by Bracelet on 16/1/11.
//  Copyright © 2016年 Odong  Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODMyOrderDetailModel.h"
#import "ODTabBarController.h"
#import "ODHelp.h"

@interface ODMyOrderDetailController : ODBaseViewController


@property(nonatomic, copy) NSString *open_id;

/**
 *  订单ID
 */
@property(nonatomic, copy) NSString *order_id;

/**
 *  是否是他人的个人中心
 */
@property(nonatomic, assign) BOOL isOther;

/**
 *  订单状态
 */
@property(nonatomic, copy) NSString *status_str;

@end
