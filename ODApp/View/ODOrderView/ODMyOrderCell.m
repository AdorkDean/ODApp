//
//  ODMyOrderCell.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyOrderCell.h"
#import "UIButton+WebCache.h"
@implementation ODMyOrderCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.userButtonView.layer.masksToBounds = YES;
    self.userButtonView.layer.cornerRadius = 15;
    self.userButtonView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userButtonView.layer.borderWidth = 1;

    
}


- (void)setModel:(ODMyOrderModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    [self.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.swap_user_avatar] forState:UIControlStateNormal];
    
    [self.contentImageView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.swap_img] forState:UIControlStateNormal];

    self.nikeLabel.text = model.swap_user_nick;
    self.nikeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.titleLabel.text = [NSString stringWithFormat:@"我去 · %@" , model.swap_title];
    self.priceLabel.text = [NSString stringWithFormat:@"%@/%@" , model.swap_price , model.swap_unit];
     self.priceLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.dateLabel.text = model.service_time;
     self.dateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
   

   
        self.statusLabel.text = model.status_str;
    
    if ([self.statusLabel.text isEqualToString:@"已取消"]) {
         self.statusLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    }else{
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
       

    }
    
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.swap_user_gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }

    
}



@end
