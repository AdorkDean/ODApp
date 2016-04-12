//
//  ODTakeOutView.m
//  ODApp
//
//  Created by Bracelet on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeOutView.h"

#import <UIImageView+WebCache.h>

@implementation ODTakeOutView

- (void)awakeFromNib {

    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.takeOutContentView.backgroundColor = [UIColor whiteColor];
    self.enterButton.layer.borderWidth = 0.5;
    self.enterButton.layer.cornerRadius = 5;
}

- (void)setModel:(ODMyTakeOutModel *)model {
    _model = model;
    
    NSURL *url = [NSURL OD_URLWithString:model.store_icon];
    
    [self.outletSignImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_E+logo"] options:SDWebImageRetryFailed];
    
    self.takeOutStatus.text = model.status_str;
    if ([model.status isEqualToString:@"4"]) {
        self.takeOutStatus.textColor = [UIColor redColor];
    }
    else {
        self.takeOutStatus.textColor = [UIColor colorGreyColor];
    }
    
    self.takeOutContentHeight.constant = 44 * model.products.count;
    
    for (UIView *view in self.takeOutContentView.subviews) {
        if (![view isKindOfClass:[UILabel class]]) return;
        UILabel *label = (UILabel *)view;
        [label removeFromSuperview];
    }
    
    for (int i = 0; i < model.products.count; i++) {        
        UILabel *takeOutNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 44 * i, 150, 44)];
        takeOutNameLabel.text = [model.products[i] valueForKeyPath:@"product_title"];
        takeOutNameLabel.textColor = [UIColor colorGloomyColor];
        takeOutNameLabel.font = [UIFont systemFontOfSize:13.5];        
        [self.takeOutContentView addSubview:takeOutNameLabel];
        
        UILabel *takeOutNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 150, 44 * i, 150 - ODLeftMargin, 44)];
        takeOutNumberLabel.text = [NSString stringWithFormat:@"x %@", [model.products[0] valueForKeyPath:@"num"]];
        takeOutNumberLabel.textColor = [UIColor colorGreyColor];
        takeOutNumberLabel.font = [UIFont systemFontOfSize:13.5];
        takeOutNumberLabel.textAlignment = NSTextAlignmentRight;
        [self.takeOutContentView addSubview:takeOutNumberLabel];
    }
    
    NSString *money = [NSString stringWithFormat:@"合计 ￥%@",model.price_show];
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:money];
    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, 2)];
    
    
    self.takeOutTotalMoney.attributedText = moneyStr;
    
    if ([model.status isEqualToString:@"1"]) {
        [self.enterButton setTitle:@"支付" forState:UIControlStateNormal];
        self.enterButton.backgroundColor = [UIColor themeColor];
        self.enterButton.layer.borderColor = [UIColor lineColor].CGColor;

    }
    else {
        [self.enterButton setTitle:@"查看" forState:UIControlStateNormal];
        self.enterButton.backgroundColor = [UIColor whiteColor];
            self.enterButton.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
}


@end
