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
    self.imageV.layer.cornerRadius = 60;
    self.nickLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.signLabel.textColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
}

@end
