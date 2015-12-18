//
//  ODBazaarViewCell.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarViewCell.h"

@implementation ODBazaarViewCell

- (void)awakeFromNib {
    
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 24;
    self.titleLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.contentLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.nameLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.timeLabel.textColor = [ODColorConversion colorWithHexString:@"#ff6666" alpha:1];
    self.statuLabel.layer.masksToBounds = YES;
    self.statuLabel.layer.cornerRadius = 5;
    self.statuLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.statuLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffd701" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headButtonClick:(UIButton *)sender {
}


-(void)showDataWithModel:(ODBazaarModel *)model
{
    self.headButton.backgroundColor = [UIColor grayColor];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.user_nick;
    self.timeLabel.text = model.task_start_date;
}

@end
