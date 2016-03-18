//
//  ODMyOrderRecordView.m
//  ODApp
//
//  Created by Bracelet on 16/3/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyOrderRecordView.h"

@implementation ODMyOrderRecordView

- (void)awakeFromNib
{
    self.checkStateLabel.layer.cornerRadius = 5;
    self.checkStateLabel.layer.borderWidth = 0.5;
    self.checkStateLabel.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 0.5f;
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

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 4;
    frame.size.height -= 4;
    
    [super setFrame:frame];
}

@end
