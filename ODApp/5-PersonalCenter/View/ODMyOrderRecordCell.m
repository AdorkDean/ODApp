//
//  ODMyOrderRecordCell.m
//  ODApp
//
//  Created by Bracelet on 16/1/8.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODMyOrderRecordCell.h"

@implementation ODMyOrderRecordCell

- (void)awakeFromNib
{
    self.checkStateLabel.layer.cornerRadius = 5;
    self.checkStateLabel.layer.borderWidth = 0.5;
    self.checkStateLabel.layer.borderColor = [UIColor lineColor].CGColor;
    self.lineHeight.constant = 0.5;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 0.5;
    
}

- (void)showDatawithModel:(ODMyOrderRecordModel *)model{

    if ([model.purpose  isEqual: @""])
    {
        self.centerPurposeDetailLabel.text = @"无";
    }
    else
    {
        self.centerPurposeDetailLabel.text = model.purpose;
    }
    
    self.centerNameDetailLabel.text = model.position_str;
    self.timeDetailLabel.text = [NSString stringWithFormat:@"%@ - %@",model.start_date_str,model.end_date_str];
    self.checkStateLabel.text = model.status_str;
}



@end
