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
    self.timeLabel.textColor = [UIColor colorGreyColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lineView.backgroundColor = [UIColor lineColor];
}

- (void)setStatus:(BOOL)status
{
    self.openButton.selected = !status;
}



@end
