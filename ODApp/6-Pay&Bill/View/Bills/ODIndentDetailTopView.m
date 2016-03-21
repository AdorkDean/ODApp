//
//  ODIndentDetailTopView.m
//  ODApp
//
//  Created by Bracelet on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODIndentDetailTopView.h"

@implementation ODIndentDetailTopView

+ (instancetype)detailTopView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(ODOrderDetailModel *)model {
    if ([model.order_status isEqualToString:@"1"] || [model.order_status isEqualToString:@"-1"]) {
        self.orderStateLabel.textColor = [UIColor lightGrayColor];
        
    }
    else {
        self.orderStateLabel.textColor = [UIColor colorRedColor];
    }
    
    if ([model.order_status isEqualToString:@"1"]) {
        self.orderStateLabel.text = @"待支付";
    }
    else if ([model.order_status isEqualToString:@"2"] || [model.order_status isEqualToString:@"3"]) {
        self.orderStateLabel.text = @"已付款";
    }
    else if ([model.order_status isEqualToString:@"4"]) {
        if ([model.swap_type isEqualToString:@"2"]) {
            self.orderStateLabel.text = @"已发货";
        }
        else {
            self.orderStateLabel.text = @"已服务";
        }
    }
    else if ([model.order_status isEqualToString:@"5"]) {
        self.orderStateLabel.text = @"已评价";
        self.orderStateLabel.textColor = [UIColor redColor];
    }
    else if ([model.order_status isEqualToString:@"-1"]) {
        self.orderStateLabel.text = @"已取消";
    }
    else if ([model.order_status isEqualToString:@"-2"]) {
        if (self.isSellDetail) {
            self.orderStateLabel.text = @"买家已申请退款";
        }
        else {
            self.orderStateLabel.text = @"已申请退款";
        }        
    }
    else if ([model.order_status isEqualToString:@"-3"]) {
        self.orderStateLabel.text = @"退款已受理";
    }
    else if ([model.order_status isEqualToString:@"-4"]) {
        self.orderStateLabel.text = @"已退款";
    }
    else if ([model.order_status isEqualToString:@"-5"]) {
        self.orderStateLabel.text = @"拒绝退款";
    }
}

@end
