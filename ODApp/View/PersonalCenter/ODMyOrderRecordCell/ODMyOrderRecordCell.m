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
    
    self.centerPurposeImageView.image = [UIImage imageNamed:@"活动目的icon"];
    self.centerNameImageView.image = [UIImage imageNamed:@"中心详情页icon3"];
    self.timeImageView.image = [UIImage imageNamed:@"中心详情页icon"];
    
    self.centerPurposeLabel.text = @"活动目的:";
    self.centerPurposeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.centerPurposeLabel.font = [UIFont systemFontOfSize:12];
    
    self.centerNameLabel.text = @"中心名称:";
    self.centerNameLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.centerNameLabel.font = [UIFont systemFontOfSize:12];
    
    self.timeLabel.text = @"活动时间:";
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    self.centerPurposeDetailLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.centerPurposeDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.centerNameDetailLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.centerNameDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.timeDetailLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.timeDetailLabel.font = [UIFont systemFontOfSize:12];
    
    self.checkStateLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.checkStateLabel.layer.borderWidth = 1;
    self.checkStateLabel.layer.borderColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
    self.checkStateLabel.font = [UIFont systemFontOfSize:10];
}

- (void)showDatawithModel:(ODMyOrderRecordModel *)model{

    self.centerPurposeDetailLabel.text = model.purpose;
    self.centerNameDetailLabel.text = model.position_str;
    self.timeDetailLabel.text = [NSString stringWithFormat:@"%@ - %@",model.start_date_str,model.end_date_str];
    self.checkStateLabel.text = model.status_str;
}



@end
