//
//  ODMyTaskCell.m
//  ODApp
//
//  Created by Odong-YG on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyTaskCell.h"

@implementation ODMyTaskCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.spaceView.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 29;
    self.headButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.headButton.layer.borderWidth = 1;
    self.lineImageView.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithRGBString:@"#484848" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
    self.nickLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(ODBazaarModel *)model{
    if (_model != model) {
        _model = model;
    }
    [self.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed completed:nil];
    self.nickLabel.text = model.user_nick;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.timeLabel.text = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    
    NSString *status = [NSString stringWithFormat:@"%@", model.task_status];
    if ([status isEqualToString:@"1"]) {
        self.statusLabel.text = @"等待派单";
    } else if ([status isEqualToString:@"2"]) {
        self.statusLabel.text = @"正在进行";
    } else if ([status isEqualToString:@"3"]) {
        self.statusLabel.text = @"已交付";
    } else if ([status isEqualToString:@"4"]) {
        self.statusLabel.text = @"任务完成";
    } else if ([status isEqualToString:@"-2"]) {
        self.statusLabel.text = @"过期任务";
    } else if ([status isEqualToString:@"0"]) {
        self.statusLabel.text = @"无效";
    }
    if ([status isEqualToString:@"-2"]) {
        self.statusLabel.textColor = [UIColor colorWithRGBString:@"#b0b0b0" alpha:1];
    }else{
        self.statusLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
    }
}
@end
