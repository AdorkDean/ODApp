//
//  ODMyOrderRecordCell.m
//  ODApp
//
//  Created by 代征钏 on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyOrderRecordCell.h"

@implementation ODMyOrderRecordCell

- (void)awakeFromNib {
    
    self.centerNameImageView.image = [UIImage imageNamed:@"中心详情页icon3"];
    self.beginTimeImageView.image = [UIImage imageNamed:@"中心详情页icon"];
    self.endTimeImageView.image = [UIImage imageNamed:@"中心详情页icon"];
    
    self.centerNameLabel.text = @"中心名称:";
    self.centerNameLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.centerNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.beginTimeLabel.text = @"开始时间:";
    self.beginTimeLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.beginTimeLabel.font = [UIFont systemFontOfSize:12];
    
    self.endTimeLabel.text = @"结束时间:";
    self.endTimeLabel.textColor = [ODColorConversion colorWithHexString:@"#8e8e8e" alpha:1];
    self.endTimeLabel.font = [UIFont systemFontOfSize:12];
    
    self.centerNameDetailLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.centerNameDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.beginTimeDetailLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.beginTimeDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.endTimeDetailLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.endTimeDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.checkStateLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.checkStateLabel.layer.borderWidth = 1;
    self.checkStateLabel.layer.borderColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1].CGColor;
    self.checkStateLabel.font = [UIFont systemFontOfSize:10];
}

- (void)showDatawithModel:(ODMyOrderRecordModel *)model{

    self.centerNameDetailLabel.text = model.position_str;
    self.beginTimeDetailLabel.text = model.start_date_str;
    self.endTimeDetailLabel.text = model.end_date_str;
    self.checkStateLabel.text = model.status_str;
}



@end
