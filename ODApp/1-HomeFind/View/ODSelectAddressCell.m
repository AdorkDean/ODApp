//
//  ODSelectAddressCell.m
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSelectAddressCell.h"

@implementation ODSelectAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineView.backgroundColor = [UIColor lineColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
