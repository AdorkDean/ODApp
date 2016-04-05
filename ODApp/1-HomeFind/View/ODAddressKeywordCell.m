//
//  ODAddressKeywordCell.m
//  ODApp
//
//  Created by Odong-YG on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODAddressKeywordCell.h"

@implementation ODAddressKeywordCell

- (void)awakeFromNib {
    [super awakeFromNib];
   self.lineView.backgroundColor = [UIColor lineColor];
}

-(void)showDataWithAMapPOI:(AMapPOI *)poi index:(NSIndexPath *)index{
    self.titleLabel.text = poi.name;
    self.detailLabel.text = poi.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
