//
//  ODLocationCell.m
//  ODApp
//
//  Created by Bracelet on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODLocationCell.h"

@implementation ODLocationCell


- (void)setModel:(ODCityNameModel *)model {
    self.cityNameLabel.text = model.name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
