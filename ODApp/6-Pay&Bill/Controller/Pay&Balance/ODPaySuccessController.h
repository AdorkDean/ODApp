//
//  ODPaySuccessController.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"

@interface ODPaySuccessController : ODPayController

@property(nonatomic, copy) NSString *payStatus;
@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, copy) NSString *swap_type;

/** 参数 */
@property (nonatomic,strong) NSDictionary *params;


@end
