//
//  ODIndentDetailView.m
//  ODApp
//
//  Created by Bracelet on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODIndentDetailView.h"

#import "UIImageView+WebCache.h"

@implementation ODIndentDetailView

+ (instancetype)detailView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    
    self.userImageView.layer.cornerRadius = 24;
    self.orderImageView.layer.cornerRadius = 5;
    
    self.orderWay.layer.cornerRadius = 5;
    self.orderWay.layer.borderColor = [UIColor lineColor].CGColor;
    self.orderWay.layer.borderWidth = 1;
}


- (void)setModel:(ODOrderDetailModel *)model {
    [self.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", [model.user valueForKeyPath:@"avatar"]]]];
    self.userNameLabel.text = [model.user valueForKeyPath:@"nick"];
    [self.orderImageView sd_setImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", [model.imgs_small[0] valueForKeyPath:@"img_url"]]]];
    self.orderTitle.text = model.title;
    self.orderWay.text = model.order_status;
    self.orderPrice.text = [NSString stringWithFormat:@"%@元/%@", model.order_price, model.unit];
    self.orderNumber.text = [NSString stringWithFormat:@"数量：%@", model.num];
    
    NSString *moneyStr = [NSString stringWithFormat:@"费用合计：%@元", model.total_price];
    NSMutableAttributedString *moneyStr1 = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [moneyStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    
    self.orderMoney.attributedText = moneyStr1;
    
    
    
    
    
    if ([model.swap_type isEqualToString:@"1"]) {
        self.orderWay.text = @" 上门服务 ";
    }
    else if ([model.swap_type isEqualToString:@"2"]) {
        self.orderWay.text = @" 快递服务 ";
    }
    else if ([model.swap_type isEqualToString:@"3"]) {
        self.orderWay.text = @" 线上服务 ";
    }
}

@end
