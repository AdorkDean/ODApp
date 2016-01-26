//
//  CenterActivityCell.m
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterActivityCell.h"
#import "UIImageView+WebCache.h"
@implementation CenterActivityCell

- (void)awakeFromNib {
    // Initialization code
    
    
    if (iPhone4_4S) {
        self.toRightSpace.constant = 210;
    }else if (iPhone5_5s){
        self.toRightSpace.constant = 210;
    }else if (iPhone6_6s){
        self.toRightSpace.constant = 260;
    }else{
        self.toRightSpace.constant = 300;
        
    }
    
    self.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
  
    
    
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius = 7;
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    self.coverImageView.layer.borderWidth = 1;
    
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];

    
    
    
}


- (void)setModel:(CenterActivityModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.date_str;
    self.addressLabel.text = model.address;
    NSURL *url = [NSURL OD_URLWithString:model.icon_url];
    [self.ActivityImageView sd_setImageWithURL:url];

    
    
}






@end
