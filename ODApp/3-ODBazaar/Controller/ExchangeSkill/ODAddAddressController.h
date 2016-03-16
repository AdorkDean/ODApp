//
//  ODAddAddressController.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODOrderAddressModel.h"

@interface ODAddAddressController : ODBaseViewController

@property(nonatomic, copy) NSString *typeTitle;
@property(nonatomic, assign) BOOL isAdd;
@property(nonatomic, copy) NSString *addressId;
@property(nonatomic, strong) ODOrderAddressDefModel *addressModel;
@property(nonatomic, assign) BOOL isDefault;


@end
