//
//  ODTakeAwayDetailController.h
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PontoDispatcher.h"
@class ODTakeOutModel;

@interface ODTakeAwayDetailController : UIViewController<PontoDispatcherCallbackDelegate>

//@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *product_id;

/**
 * 商品ID
 */
@property (nonatomic, strong) NSString *takeAwayTitle;

/**
 * 是否是购物车
 */
@property (nonatomic, assign) BOOL isCart;

/**
 * 是否是订单详情
 */
@property (nonatomic, assign) BOOL isOrderDetail;

/**
 * 订单ID
 */
@property (nonatomic, strong) NSString *order_id;

/** <#desc#> */
@property (nonatomic, strong) ODTakeOutModel *takeOut;

@end

