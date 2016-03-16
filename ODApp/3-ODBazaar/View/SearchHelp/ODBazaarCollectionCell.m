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
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"#ffd701" alpha:1];
}

- (void)setModel:(ODBazaarRequestHelpTasksModel *)model
{
    [self.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.user_nick;
    //设置Label显示不同大小的字体
    NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 5)];
    self.timeLabel.attributedText = noteStr;
    self.statusLabel.text = @"任务开始";
    
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-83, 30) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    self.contentLabelConstraint.constant = size.height;
}


@end
