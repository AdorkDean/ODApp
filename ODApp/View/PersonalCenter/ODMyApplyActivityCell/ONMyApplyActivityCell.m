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
    
    self.timelabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    
    self.adressLabel.textColor =  [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.adressLabel.layer.cornerRadius = 4;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1].CGColor;
    
}

- (void)showDataWithModel:(ODMyApplyActivityModel *)model{

    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    
    self.titleLabel.text = model.content;
    self.timelabel.text = model.date_str;
    
    self.adressLabel.text = model.address;
    NSString *str = [NSString stringWithFormat:@"%@",model.status];
    if ([str isEqualToString: @"0"]) {
        self.checkLabel.text = @"审核中";
    }else if ([str isEqualToString: @"1"]){
        self.checkLabel.text = @"审核通过";
    }else  {
        self.checkLabel.text = @"审核失败";
    }
}

@end
