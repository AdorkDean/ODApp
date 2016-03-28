//
//  ODSubmitView.h
//  ODApp
//
//  Created by Bracelet on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarExchangeSkillDetailModel.h"


@interface ODSubmitOrderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;

@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *skillPriceLabel;

@property(nonatomic, strong) ODBazaarExchangeSkillDetailModel *model;


+ (instancetype)submitOrderView;

@end
