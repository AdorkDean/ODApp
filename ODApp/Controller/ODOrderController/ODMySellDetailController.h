//
//  ODMySellDetailController.h
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODMySellDetailController : ODBaseViewController




@property (nonatomic , copy) NSString *orderType;


@property (nonatomic , copy) NSString *orderId;



@property (nonatomic , copy) NSString *orderStatus;


@property(nonatomic,copy)void(^getRefresh)(NSString *isRefresh);



@end
