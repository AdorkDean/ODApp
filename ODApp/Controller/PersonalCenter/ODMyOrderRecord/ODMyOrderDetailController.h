//
//  ODMyOrderDetailController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"

#import "ODAPIManager.h"
#import "ODMyOrderDetailModel.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"

@interface ODMyOrderDetailController : ODBaseViewController

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *orderView;

@property (nonatomic, strong) UILabel *checkLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *devicesArray;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *managers;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, strong)ODMyOrderDetailModel *model;

@property (nonatomic, strong) UIButton *cancelOrderButton;

@property (nonatomic, assign) BOOL isOther;

@end
