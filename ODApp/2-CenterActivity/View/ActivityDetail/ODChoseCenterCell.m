//
//  ODChoseCenterCell.m
//  ODApp
//
//  Created by Bracelet on 16/3/11.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODChoseCenterCell.h"


@implementation ODChoseCenterCell


- (void)setModel:(ODStorePlaceListModel *)model {
    self.titleLabel.text = model.name;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
