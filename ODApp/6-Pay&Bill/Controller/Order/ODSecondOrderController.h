//
//  ODSecondOrderController.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarExchangeSkillDetailModel.h"

@interface ODSecondOrderController : ODBaseViewController

@property(nonatomic, strong) NSString *openId;
@property(nonatomic, strong) ODBazaarExchangeSkillDetailModel *informationModel;
@property(nonatomic, strong) NSMutableDictionary *dict;
@end
