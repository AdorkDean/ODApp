//
//  ODIndentDetailView.h
//  ODApp
//
//  Created by Bracelet on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODOrderDetailModel.h"

@interface ODIndentDetailView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (weak, nonatomic) IBOutlet UILabel *orderTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderWay;

@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@property (weak, nonatomic) IBOutlet UILabel *orderMoney;

@property (nonatomic, strong) ODOrderDetailModel *model;

+ (instancetype)detailView;


@end
