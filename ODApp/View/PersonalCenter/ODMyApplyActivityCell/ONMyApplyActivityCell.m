//
//  ONMyApplyActivityCell.m
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ONMyApplyActivityCell.h"

@implementation ONMyApplyActivityCell

- (void)awakeFromNib {
    
    self.timelabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];    
    self.adressLabel.textColor =  [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.titleImageView.layer.cornerRadius = 7;
    self.titleImageView.layer.masksToBounds = YES;
    
}

- (void)showDataWithModel:(ODMyApplyActivityModel *)model{

   
    
    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.icon_url]];

    
    
    self.titleLabel.text = model.content;
    self.timelabel.text = model.date_str;
    
    self.adressLabel.text = model.address;
    self.applyNumLabel.text = [NSString stringWithFormat:@"%@人已报名", model.apply_cnt];

}

@end
