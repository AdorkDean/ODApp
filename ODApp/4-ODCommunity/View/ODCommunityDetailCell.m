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
    self.nickName.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithRGBString:@"#484848" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithRGBString:@"#b0b0b0" alpha:1];
    [self.replyButton setTitleColor:[UIColor colorWithRGBString:@"#484848" alpha:1] forState:UIControlStateNormal];
    self.lineImageView.backgroundColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
    self.lineImageViewConstraint.constant = 0.5;
    
}

-(void)setModel:(ODCommunityDetailModel *)model
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
