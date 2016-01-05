//
//  ODBazaarSearchCell.m
//  ODApp
//
//  Created by Odong-YG on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarSearchCell.h"

@implementation ODBazaarSearchCell

- (void)awakeFromNib {
    self.nameLabel.textColor = [ODColorConversion colorWithHexString:@"#000000" alpha:1];
    self.lineImageView.backgroundColor = [ODColorConversion colorWithHexString:@"#e6e6e6" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
