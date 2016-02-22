//
//  ODPaySuccessController.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODPaySuccessController : ODBaseViewController

@property (nonatomic , copy) NSString *payStatus;
@property (nonatomic , copy) NSString *orderId;
@property (nonatomic , copy) NSString *swap_type;

@end
