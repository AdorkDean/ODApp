//
//  ODInformationController.h
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODInformationController : ODBaseViewController

@property (nonatomic , copy) NSString *phoneNumber;
@property (nonatomic , copy) NSString *password;


@property(nonatomic,copy)void(^informationBlock)(NSString *phone , NSString *password);

@end
