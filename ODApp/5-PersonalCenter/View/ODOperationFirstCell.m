//
//  ODOperationFirstCell.m
//  ODApp
//
//  Created by zhz on 16/2/19.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOperationFirstCell.h"

@implementation ODOperationFirstCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.titleLabel.backgroundColor = [UIColor colorRedColor];
    
 
    
    
     self.titleLabel.layer.masksToBounds = YES;
     self.titleLabel.layer.cornerRadius = 5;
     self.titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
     self.titleLabel.layer.borderWidth = 1;
    
    
}

@end
