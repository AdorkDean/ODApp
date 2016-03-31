//
//  ODMyTaskViolationsCell.m
//  ODApp
//
//  Created by Odong-YG on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyTaskViolationsCell.h"

@implementation ODMyTaskViolationsCell

- (void)awakeFromNib {
    self.autoresizingMask = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.spaceView.backgroundColor = [UIColor backgroundColor];
    self.statusLabel.textColor = [UIColor colorGreyColor];
    [self.deleteButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor colorGloomyColor];
    self.reasonLabel.textColor = [UIColor colorRedColor];
    self.detailReasonLabel.textColor = [UIColor colorGloomyColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ODBazaarModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.statusLabel.text = @"违规任务";
    self.titleLabel.text = model.title;
    self.detailReasonLabel.text = model.reason;
    self.reasonLabel.text = @"违规理由 : ";
}

@end
