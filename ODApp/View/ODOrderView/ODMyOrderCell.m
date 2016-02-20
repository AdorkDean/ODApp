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
        self.statusLabel.text = @"已下单未付款";
    }else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"已付款未发货";
    }else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已付款";
    }else if ([status isEqualToString:@"4"]) {
        self.statusLabel.text = @"已发货";
    }else if ([status isEqualToString:@"5"]) {
        self.statusLabel.text = @"已完成";
    }else if ([status isEqualToString:@"-1"]) {
        self.statusLabel.text = @"已取消";
    }else if ([status isEqualToString:@"-2"]) {
        self.statusLabel.text = @"退款申请";
    }else if ([status isEqualToString:@"-3"]) {
        self.statusLabel.text = @"退款已确认";
    }else if ([status isEqualToString:@"-4"]) {
        self.statusLabel.text = @"已退款";
    }else if ([status isEqualToString:@"-5"]) {
        self.statusLabel.text = @"拒绝退款";
    }








       
    
    
    NSString *gender = [NSString stringWithFormat:@"%@" , model.swap_user_gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
        self.gerderImgeView.image = [UIImage imageNamed:@"icon_man"];
    }
    
    


}

@end
