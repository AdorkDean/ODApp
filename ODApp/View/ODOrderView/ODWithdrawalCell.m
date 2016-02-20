//
//  ODWithdrawalCell.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODWithdrawalCell.h"

@implementation ODWithdrawalCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(ODBalanceModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    
    self.priceLabel.text = model.amount;
    self.dataLabel.text = model.date;
    self.statusLabel.text = model.status_str;
    
    
    
    
}





@end
