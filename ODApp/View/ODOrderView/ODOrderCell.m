//
//  ODOrderCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderCell.h"

@implementation ODOrderCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.userImgeView.layer.masksToBounds = YES;
    self.userImgeView.layer.cornerRadius = 25;
    self.userImgeView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImgeView.layer.borderWidth = 1;

    
    self.backgroundColor = [UIColor whiteColor];
    
    
}

@end
