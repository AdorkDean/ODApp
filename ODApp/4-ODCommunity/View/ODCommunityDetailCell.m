//
//  ODCommunityDetailCell.m
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityDetailCell.h"

@implementation ODCommunityDetailCell

- (void)awakeFromNib {
    self.timeLabelSpaceConstant = self.timeLabelSpace.constant;
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 20;
    self.nickName.textColor = [UIColor blackColor];
    self.contentLabel.textColor = [UIColor colorGloomyColor];
    self.timeLabel.textColor = [UIColor colorGreyColor];
    [self.replyButton setTitleColor:[UIColor colorGloomyColor] forState:UIControlStateNormal];
    self.lineImageView.backgroundColor = [UIColor lineColor];
    self.lineImageViewConstraint.constant = 0.5;
    
}

-(void)setModel:(ODCommunityDetailModel *)model
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
