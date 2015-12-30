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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headButton:(UIButton *)sender {
}

- (IBAction)replyButton:(UIButton *)sender {
}

- (IBAction)deleteButton:(UIButton *)sender {
}

-(void)showDataWithModel:(ODCommunityDetailModel *)model
{
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.created_at;
}

@end
