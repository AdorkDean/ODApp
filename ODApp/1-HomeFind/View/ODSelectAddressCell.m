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
}

-(void)showDataWithNSDictionary:(NSDictionary *)dict index:(NSIndexPath *)index{
    if (index.row == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_id"];
    }else{
        self.iconImageView.image = [UIImage imageNamed:@"icon_id_Unchecked"];
    }
    self.titleLabel.text = dict[@"name"];
    self.detailAddressLabel.text = dict[@"detail"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
