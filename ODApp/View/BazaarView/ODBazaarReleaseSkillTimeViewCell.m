//
//  ODBazaarReleaseSkillTimeViewCell.m
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarReleaseSkillTimeViewCell.h"

@implementation ODBazaarReleaseSkillTimeViewCell

- (void)awakeFromNib {
    // Initialization code
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
