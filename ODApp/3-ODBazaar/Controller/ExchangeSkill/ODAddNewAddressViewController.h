//
//  ODAddNewAddressViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODOrderAddressModel.h"

@interface ODAddNewAddressViewController : ODBaseViewController

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *addressTitle;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *naviTitle;
@property(nonatomic,copy)NSString *addressId;
@property(nonatomic, strong) ODOrderAddressDefModel *addressModel;
@property(nonatomic, assign) BOOL isDefault;

@end
