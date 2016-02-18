//
//  ODSecondOrderDetailController.h
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODSecondOrderDetailController : ODBaseViewController

@property (nonatomic , copy) NSString *order_id;

@property (nonatomic , copy) NSString *orderType;

@property(nonatomic,copy)void(^getRefresh)(NSString *isRefresh);





@end
