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

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTakeOut:(ODTakeOutModel *)takeOut
{
    _takeOut = takeOut;
    
    self.titleLabel.text = takeOut.title;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", takeOut.shopNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", takeOut.price_show];
}

- (IBAction)plusButtonClick:(id)sender {
    NSInteger number = self.takeOut.shopNumber;
    if (number < 0) return;
    number += 1;
    self.takeOut.shopNumber = number;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    
    // 发送通知, 修改购物车商品数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNumber" object:self];
}

- (IBAction)minusButtonClick:(id)sender {
    NSInteger number = self.takeOut.shopNumber;
    if (number <= 0) return;
    number -= 1;
    self.takeOut.shopNumber = number;
    if (number == 0)
    {
        if ([self.delegate respondsToSelector:@selector(shopCartListcell:RemoveCurrentRow:)])
        {
            [self.delegate shopCartListcell:self RemoveCurrentRow:self.takeOut];
        }
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    
    // 发送通知, 修改购物车商品数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minusNumber" object:self];
}

@end