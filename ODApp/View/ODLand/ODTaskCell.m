//
//  ODTaskCell.m
//  ODApp
//
//  Created by zhz on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODTaskCell.h"

@implementation ODTaskCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 30;
    self.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageView.layer.borderWidth = 1;
    
    
    
    
}

@end
