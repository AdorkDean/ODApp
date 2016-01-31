//
//  ODCollectionCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCollectionCell.h"

@implementation ODCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.userImageButton.layer.masksToBounds = YES;
    self.userImageButton.layer.cornerRadius = 30;
    self.userImageButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageButton.layer.borderWidth = 1;

    
    
}

@end
