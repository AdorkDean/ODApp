//
//  ODNewActivityCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNewActivityCell.h"
#import "UIImageView+WebCache.h"

@interface ODNewActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end


@implementation ODNewActivityCell

- (void)setModel:(ODActivityListModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.icon_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.date_str;
    self.addressLabel.text = model.address;
    self.numberLabel.text = [NSString stringWithFormat:@"%zd人报名",model.apply_cnt];
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.od_height -= 2;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
