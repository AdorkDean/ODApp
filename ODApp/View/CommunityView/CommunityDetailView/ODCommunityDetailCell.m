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
    
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 20;
    self.nickName.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.contentLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.timeLabel.textColor = [ODColorConversion colorWithHexString:@"#b0b0b0" alpha:1];
    [self.replyButton setTitleColor:[ODColorConversion colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
    self.lineImageView.backgroundColor = [ODColorConversion colorWithHexString:@"#e6e6e6" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
