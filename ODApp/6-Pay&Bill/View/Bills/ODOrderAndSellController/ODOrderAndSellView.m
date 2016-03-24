//
//  ODOrderAndSellView.m
//  ODApp
//
//  Created by Bracelet on 16/3/23.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderAndSellView.h"
#import "UIImageView+WebCache.h"

@implementation ODOrderAndSellView

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 15;
    self.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageView.layer.borderWidth = 0.5;
    
    self.contentImageView.layer.borderColor = [UIColor lineColor].CGColor;
    self.contentImageView.layer.masksToBounds = YES;
    self.contentImageView.layer.borderWidth = 0.5f;
    self.contentImageView.layer.cornerRadius = 5;
    
}


- (void)dealWithBuyModel:(ODMyOrderModel *)model {
    [self.userImageView sd_setImageWithURL:[NSURL OD_URLWithString: model.swap_user_avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    
    
    [self.contentImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.swap_img]];
    
    self.nikeLabel.text = model.swap_user_nick;
    self.nikeLabel.textColor = [UIColor colorGraynessColor];
    self.titleLabel.text = [NSString stringWithFormat:@"我去 · %@" , model.swap_title];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" , model.swap_price , model.swap_unit];
    self.priceLabel.textColor = [UIColor colorGraynessColor];
    self.dateLabel.text = model.order_created_at;
    self.dateLabel.textColor = [UIColor colorGraynessColor];
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    if ([status isEqualToString:@"1"]) {
        self.statusLabel.text = @"待支付";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }
    else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"4"]) {
        
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
    
    
    if ([gender isEqualToString:@"2"]) {
        
        self.genderImageWith.constant = 13;
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.genderImageWith.constant = 6;
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
        
    }
    
    
    
    
}


- (void)dealWithSellModel:(ODMySellModel *)model
{
    
    [self.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.order_user_avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    
    [self.contentImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.swap_img]];
    
    
    self.nikeLabel.text = model.order_user_nick;
    self.nikeLabel.textColor = [UIColor colorGraynessColor];
    self.titleLabel.text = [NSString stringWithFormat:@"我去 · %@" , model.swap_title];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" , model.swap_price , model.swap_unit];
    self.priceLabel.textColor = [UIColor colorGraynessColor];
    self.dateLabel.text = model.order_created_at;
    self.dateLabel.textColor = [UIColor colorGraynessColor];
    
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    
    if ([status isEqualToString:@"1"]) {
        self.statusLabel.text = @"待支付";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }
    else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已付款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"4"]) {
        
        NSString *swap_Type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        if ([swap_Type isEqualToString:@"2"]) {
            
            self.statusLabel.text = @"已发货";
            self.statusLabel.textColor = [UIColor redColor];
            
        }
        else{
                        self.statusLabel.text = @"已服务";
            self.statusLabel.textColor = [UIColor redColor];
        }
        
    }
    else if ([status isEqualToString:@"5"]) {
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"-1"]) {
        self.statusLabel.text = @"已取消";
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }
    else if ([status isEqualToString:@"-2"]) {
        self.statusLabel.text = @"买家已申请退款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"-3"]) {
        self.statusLabel.text = @"退款已受理";
        self.statusLabel.textColor = [UIColor redColor];
    }
    else if ([status isEqualToString:@"-4"]) {
        self.statusLabel.text = @"已退款";
        self.statusLabel.textColor = [UIColor redColor];
        
    }
    else if ([status isEqualToString:@"-5"]) {
        self.statusLabel.text = @"拒绝退款";
        self.statusLabel.textColor = [UIColor redColor];
    }
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.order_user_gender];
    if ([gender isEqualToString:@"2"]) {
        self.genderImageWith.constant = 13;
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }
    else{
        self.genderImageWith.constant = 6;
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }
}


@end
