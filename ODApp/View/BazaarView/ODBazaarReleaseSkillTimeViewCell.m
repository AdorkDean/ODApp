//
//  ODBazaarReleaseSkillTimeViewCell.m
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarReleaseSkillTimeViewCell.h"

@implementation ODBazaarReleaseSkillTimeViewCell

- (void)awakeFromNib
{
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
}

- (void)setStatus:(BOOL)status
{
    self.openButton.selected = !status;
}



@end
