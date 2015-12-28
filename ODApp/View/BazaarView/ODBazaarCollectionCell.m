//
//  ODBazaarCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarCollectionCell.h"

@implementation ODBazaarCollectionCell

- (void)awakeFromNib {
    
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 24;
    self.titleLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.contentLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.nameLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.timeLabel.textColor = [ODColorConversion colorWithHexString:@"#ff6666" alpha:1];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.textColor = [ODColorConversion colorWithHexString:@"#484848" alpha:1];
    self.statusLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffd701" alpha:1];

}

-(void)shodDataWithModel:(ODBazaarModel *)model
{
    [self.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.user_nick;
    self.timeLabel.text = model.task_start_date;
}

- (IBAction)headButton:(UIButton *)sender {
}
@end
