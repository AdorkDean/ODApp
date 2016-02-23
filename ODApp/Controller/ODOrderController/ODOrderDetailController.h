//
//  ODOrderDetailController.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODOrderDetailController : ODBaseViewController

@property (nonatomic , copy) NSString *order_id;

@property (nonatomic , copy) NSString *orderType;

@property(nonatomic,copy)void(^getRefresh)(NSString *isRefresh);







@end
