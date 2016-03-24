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

    self.nameLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
    self.lineImageView.backgroundColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
    self.lineImageViewConstraint.constant = 0.5;
}

@end
