//
//  ODPayController.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODPayController : ODBaseViewController

/** 交易类型 */
@property (nonatomic,copy) NSString *tradeType;


@property(nonatomic, copy) NSString *payType;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *OrderTitle;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *swap_type;

- (void)payAction:(UIButton *)sender;
- (void)getWeiXinDataWithParam:(NSDictionary *)params;

@end
