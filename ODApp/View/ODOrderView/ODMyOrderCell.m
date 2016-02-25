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
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" , model.swap_price , model.swap_unit];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.dateLabel.text = model.order_created_at;
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    
    
    if ([status isEqualToString:@"1"]) {
        self.statusLabel.text = @"待支付";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"4"]) {
        
        
        NSString *swap_Type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        if ([swap_Type isEqualToString:@"2"]) {
            
            self.statusLabel.text = @"已发货";
            self.statusLabel.textColor = [UIColor redColor];
            
        }else{
            
            self.statusLabel.text = @"已服务";
            self.statusLabel.textColor = [UIColor redColor];
        }
        
    }else if ([status isEqualToString:@"5"]) {
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-1"]) {
        self.statusLabel.text = @"已取消";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"-2"]) {
        self.statusLabel.text = @"已申请退款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-3"]) {
        self.statusLabel.text = @"退款已受理";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-4"]) {
        self.statusLabel.text = @"已退款";
        self.statusLabel.textColor = [UIColor redColor];

    }else if ([status isEqualToString:@"-5"]) {
        self.statusLabel.text = @"拒绝退款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.swap_user_gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }
    
    
    
    
}




- (void)dealWithSellModel:(ODMySellModel *)model
{
    
    [self.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.order_user_avatar] forState:UIControlStateNormal];
    
    [self.contentImageView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.swap_img] forState:UIControlStateNormal];
    
    self.nikeLabel.text = model.order_user_nick;
    self.nikeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.titleLabel.text = [NSString stringWithFormat:@"我去 · %@" , model.swap_title];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" , model.swap_price , model.swap_unit];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.dateLabel.text = model.order_created_at;
    self.dateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    
    if ([status isEqualToString:@"1"]) {
        self.statusLabel.text = @"待支付";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"4"]) {
        
        
        NSString *swap_Type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        
        
        
        if ([swap_Type isEqualToString:@"2"]) {
            
            self.statusLabel.text = @"已发货";
            self.statusLabel.textColor = [UIColor redColor];
            
        }else{
            
            self.statusLabel.text = @"已服务";
            self.statusLabel.textColor = [UIColor redColor];
        }
        
    }else if ([status isEqualToString:@"5"]) {
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-1"]) {
        self.statusLabel.text = @"已取消";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"-2"]) {
        self.statusLabel.text = @"买家已申请退款";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-3"]) {
        self.statusLabel.text = @"退款已受理";
        self.statusLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-4"]) {
        self.statusLabel.text = @"已退款";
        self.statusLabel.textColor = [UIColor redColor];

    }else if ([status isEqualToString:@"-5"]) {
        self.statusLabel.text = @"拒绝退款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.order_user_gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }
    
    
    
    
    
    
    
}




@end
