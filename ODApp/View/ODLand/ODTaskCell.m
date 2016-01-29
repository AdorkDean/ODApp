//
//  ODTaskCell.m
//  ODApp
//
//  Created by zhz on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODTaskCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation ODTaskCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.userImageViewButton.layer.masksToBounds = YES;
    self.userImageViewButton.layer.cornerRadius = 30;
    self.userImageViewButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageViewButton.layer.borderWidth = 1;
    
    
    
    
}

- (void)setModel:(ODBazaarModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
   
   
    [self.userImageViewButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal];
    
    
    
    self.nickLabel.text = model.user_nick;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    if ([status isEqualToString:@"1"]) {
        self.typeLabel.text = @"等待派单";
        self.typeLabel.textColor = [UIColor redColor];
        
        
    }else if ([status isEqualToString:@"2"]) {
        
        self.typeLabel.text = @"进行中";
        self.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"3"]) {
        
        self.typeLabel.text = @"已交付";
        self.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"4"]) {
        
        self.typeLabel.text = @"任务完成";
        self.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-2"]) {
        
        self.typeLabel.text = @"过期任务";
        self.typeLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"0"]) {
        
        self.typeLabel.text = @"无效";
        self.typeLabel.textColor = [UIColor redColor];
    }
    
    
    //设置Label显示不同大小的字体
    NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 5)];
    self.timeLabel.attributedText = noteStr;

    
    
    
    
}




@end
