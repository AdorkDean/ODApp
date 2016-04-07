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
    self.titleLabel.textColor = [UIColor colorWithRGBString:@"#000000"];
    self.detailLabel.textColor = [UIColor colorGreyColor];
}

-(void)showDataWithAMapPOI:(AMapPOI *)poi{
    self.titleLabel.text = poi.name;
    self.detailLabel.text = poi.address;
}

@end
