//
//  ODOrderAndSellView.h
//  ODApp
//
//  Created by Bracelet on 16/3/23.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODMyOrderModel.h"
#import "ODMySellModel.h"

@interface ODOrderAndSellView : UITableViewCell


@property(weak, nonatomic) IBOutlet NSLayoutConstraint *genderImageWith;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property(weak, nonatomic) IBOutlet UIImageView *gerderImgeView;
@property(weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property(weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;


@property(nonatomic, strong) ODMyOrderModel *model;


- (void)dealWithSellModel:(ODMySellModel *)model;

- (void)dealWithBuyModel:(ODMyOrderModel *)model;



@end
