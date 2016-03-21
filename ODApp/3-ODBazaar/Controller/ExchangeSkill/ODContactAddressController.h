//
//  ODContactAddressController.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODContactAddressController : ODBaseViewController

@property(nonatomic, copy) void(^getAddressBlock)(NSString *address, NSString *addressId, NSString *isAddress);

@property(nonatomic, copy) NSString *addressId;


/**
 * 外卖
 */
@property (nonatomic, assign) BOOL isTakeOut;


@end
