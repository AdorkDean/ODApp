//
//  ODMyOrderCell.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODMyOrderModel.h"
#import "ODMySellModel.h"
@interface ODMyOrderCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIButton *userButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *gerderImgeView;
@property (weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic , strong) ODMyOrderModel *model;


- (void)dealWithSellModel:(ODMySellModel *)model;




@end
