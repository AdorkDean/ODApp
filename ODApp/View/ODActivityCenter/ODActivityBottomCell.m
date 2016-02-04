//
//  ODActivityBottomCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityBottomCell.h"

@implementation ODActivityBottomCell

- (void)awakeFromNib
{
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_share_activity"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"icon_Zambia_default"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"icon_Zambia_Selected"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
