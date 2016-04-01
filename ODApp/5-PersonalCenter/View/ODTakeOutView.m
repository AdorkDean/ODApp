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
    self.enterButton.layer.borderColor = [UIColor lineColor].CGColor;
    self.enterButton.layer.borderWidth = 0.5;
    self.enterButton.layer.cornerRadius = 5;
}

- (void)setModel:(ODMyTakeOutModel *)model {
    _model = model;
    self.outletSignImageView.image = [UIImage imageNamed:@""];
    self.takeOutStatus.text = model.status_str;
    
    self.takeOutContentHeight.constant = 44 * model.products.count;
    
    for (UIView *view in self.takeOutContentView.subviews) {
        if (![view isKindOfClass:[UILabel class]]) return;
        UILabel *label = (UILabel *)view;
        label.text = @"";
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
    
    self.takeOutTotalMoney.text = [NSString stringWithFormat:@"合计 ￥%.2f",model.price_show];
    
    if ([model.status isEqualToString:@"1"]) {
        [self.enterButton setTitle:@"支付" forState:UIControlStateNormal];
        self.enterButton.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
    }
    else {
        [self.enterButton setTitle:@"查看" forState:UIControlStateNormal];
        self.enterButton.backgroundColor = [UIColor whiteColor];
    }
}


@end
