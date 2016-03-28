//
//  ODSubmitController.h
//  ODApp
//
//  Created by Bracelet on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODBazaarExchangeSkillDetailModel.h"


@interface ODSubmitOrderController : ODBaseViewController

@property (nonatomic, assign) int swap_type;

@property (nonatomic, strong) ODBazaarExchangeSkillDetailModel *model;


@end
