//
//  ODOrderController.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarExchangeSkillDetailModel.h"

@interface ODOrderController : ODBaseViewController

@property(nonatomic, strong) ODBazaarExchangeSkillDetailModel *informationModel;

@property(nonatomic, strong)NSMutableDictionary *dict;

@end
