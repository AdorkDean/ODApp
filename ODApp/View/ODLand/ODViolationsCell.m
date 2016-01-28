//
//  ODViolationsCell.m
//  ODApp
//
//  Created by zhz on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODViolationsCell.h"

@implementation ODViolationsCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.reasonTextView.scrollEnabled = NO;

    
}


- (void)setModel:(ODBazaarModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    
    
    self.titleLabel.text = model.title;
    self.reasonTextView.text = model.reason;
    
    
    
}



@end
