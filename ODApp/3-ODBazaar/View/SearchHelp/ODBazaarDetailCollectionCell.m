//
//  ODBazaarDetailCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarDetailCollectionCell.h"

@implementation ODBazaarDetailCollectionCell

- (void)awakeFromNib {
    // Initialization code
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 40;
    self.nickLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.signLabel.textColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
}

-(void)setModel:(ODBazaarDetailApplysModel *)model{
    [self.imageV sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    self.nickLabel.text = model.user_nick;
    self.signLabel.text = model.sign;
}

@end
