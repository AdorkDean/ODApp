//
//  ODSelectAddressCell.m
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSelectAddressCell.h"

@implementation ODSelectAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = [UIColor lineColor];
    self.titleLabel.textColor = [UIColor colorWithRGBString:@"#000000"];
    self.addressLabel.textColor = [UIColor colorGreyColor];
}

-(void)showDataWithAMapPOI:(AMapPOI *)poi index:(NSIndexPath *)index{
    if (index.row == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_id"];
        NSString *str = [NSString stringWithFormat:@"[当前]%@",poi.name];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorRedColor] range:NSMakeRange(0, 4)];
        self.titleLabel.attributedText = noteStr;
        self.addressLabel.textColor = [UIColor colorWithRGBString:@"#000000"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"icon_id_Unchecked"];
        self.titleLabel.text = poi.name;
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@",poi.address];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
