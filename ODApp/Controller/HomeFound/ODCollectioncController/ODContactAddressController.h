//
//  ODContactAddressController.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODContactAddressController : ODBaseViewController

@property(nonatomic,copy)void(^getAddressBlock)(NSString *address);



@end
