//
//  ODShopCartListCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODShopCartListCell.h"
#import "ODTakeOutModel.h"

@interface ODShopCartListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation ODShopCartListCell

- (void)setTakeOut:(ODTakeOutModel *)takeOut
{
    _takeOut = takeOut;
    // 设置数据
    self.titleLabel.text = takeOut.title;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", takeOut.shopNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", takeOut.price_show];
}

/**
 *  点击加号按钮
 */
- (IBAction)plusButtonClick
{
    NSInteger number = self.takeOut.shopNumber;
    number += 1;
    self.takeOut.shopNumber = number;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    if ([self.delegate respondsToSelector:@selector(shopCartListcell:DidClickMinusButton:)])
    {
        [self.delegate shopCartListcell:self DidClickPlusButton:self.takeOut];
    }
}

/**
 *  点击减号按钮
 */
- (IBAction)minusButtonClick
{
    NSInteger number = self.takeOut.shopNumber;
    if (number <= 0) return;
    number -= 1;
    self.takeOut.shopNumber = number;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    
    if ([self.delegate respondsToSelector:@selector(shopCartListcell:DidClickPlusButton:)])
    {
        [self.delegate shopCartListcell:self DidClickMinusButton:self.takeOut];
    }
}

@end
