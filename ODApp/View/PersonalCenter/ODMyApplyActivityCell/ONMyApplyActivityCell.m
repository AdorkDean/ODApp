//
//  ONMyApplyActivityCell.m
//  ODApp
//
//  Created by 代征钏 on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ONMyApplyActivityCell.h"

@implementation ONMyApplyActivityCell

- (void)awakeFromNib {
    
    self.timelabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    
    self.adressLabel.textColor =  [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.adressLabel.layer.cornerRadius = 4;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
    
}

- (void)showDataWithModel:(ODMyApplyActivityModel *)model{

   
    
    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.icon_url]];

    
    
    self.titleLabel.text = model.content;
    self.timelabel.text = model.date_str;
    
    self.adressLabel.text = model.address;
    NSString *str = [NSString stringWithFormat:@"%@",model.status];
    self.checkLabel.layer.cornerRadius = 5;
    if ([str isEqualToString: @"0"]) {
        self.checkLabel.text = @"报名审核中";
    }else if ([str isEqualToString: @"1"]){
        self.checkLabel.text = @"审核已通过";
    }else  {
        self.checkLabel.text = @"审核未通过";
    }
}

@end
