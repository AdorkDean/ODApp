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
    self.userButtonView.layer.cornerRadius = 20;
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
    self.titleLabel.text = model.swap_title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@/%@" , model.swap_price , model.swap_unit];
    self.dateLabel.text = model.service_time;
    
    NSString *order_status = [NSString stringWithFormat:@"%@" , model.order_status];
    NSString *pay_status = [NSString stringWithFormat:@"%@" , model.pay_status];
    
    if ([pay_status isEqualToString:@"0"]) {
        self.statusLabel.textColor = [UIColor redColor];
        self.statusLabel.text = @"待支付";
    }else{
        
        self.statusLabel.textColor = [UIColor lightGrayColor];
        self.statusLabel.text = @"支付成功";

    }
    
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.swap_user_gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }

    
    
}



@end
