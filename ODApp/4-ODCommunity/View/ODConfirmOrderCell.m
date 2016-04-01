//
//  ODConfirmOrderCell.m
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODConfirmOrderCell.h"

@implementation ODConfirmOrderCell

- (void)awakeFromNib {
    
    self.nameLabel.textColor = [UIColor colorGloomyColor];
    self.countLabel.textColor = [UIColor colorGreyColor];
    self.priceLabel.textColor = [UIColor redColor];
    self.lineView.backgroundColor = [UIColor backgroundColor];
}

-(void)setModel:(ODConfirmOrderModelShopcart_list *)model{
    self.nameLabel.text = model.obj_title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",model.price_show];
    self.countLabel.text = [NSString stringWithFormat:@"X %@",model.num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
