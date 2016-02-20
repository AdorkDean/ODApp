//
//  ODWithdrawalCell.h
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBalanceModel.h"
@interface ODWithdrawalCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (nonatomic , strong) ODBalanceModel *model;

@end
