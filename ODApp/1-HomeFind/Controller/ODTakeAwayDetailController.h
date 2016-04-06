//
//  ODTakeAwayDetailController.h
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"
#import "PontoDispatcher.h"
@class ODTakeOutModel;

@interface ODTakeAwayDetailController : ODBaseViewController <PontoDispatcherCallbackDelegate>

@property (nonatomic, strong) UIWebView *webView;

/**
 * 详情title
 */
@property (nonatomic, strong) NSString *takeAwayTitle;

/**
 * 是否是订单详情
 */
@property (nonatomic, assign) BOOL isOrderDetail;

/**
 * 商品ID
 */
@property (nonatomic, copy) NSString *product_id;

/**
 * 订单ID
 */
@property (nonatomic, strong) NSString *order_id;

/**
 * order_no 
 */
@property (nonatomic,copy) NSString *orderNo;

@property (nonatomic, strong) ODTakeOutModel *takeOut;

@end

