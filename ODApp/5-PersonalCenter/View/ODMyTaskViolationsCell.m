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
    self.spaceView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"#ff6666" alpha:1] forState:UIControlStateNormal];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.reasonLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.detailReasonLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
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
