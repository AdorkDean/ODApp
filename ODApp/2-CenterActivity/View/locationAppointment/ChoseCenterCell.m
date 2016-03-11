//
//  ChoseCenterCell.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ChoseCenterCell.h"

@implementation ChoseCenterCell

- (void)awakeFromNib {
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.lineViewConstraint.constant = 0.5;
}

@end
