//
//  ODBazaarRewardCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 16/1/22.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarRewardCollectionCell.h"

@implementation ODBazaarRewardCollectionCell

- (void)awakeFromNib {

    self.nameLabel.textColor = [UIColor blackColor];
    self.lineImageView.backgroundColor = [UIColor lineColor];
    self.lineImageViewConstraint.constant = 0.5;
}

@end
