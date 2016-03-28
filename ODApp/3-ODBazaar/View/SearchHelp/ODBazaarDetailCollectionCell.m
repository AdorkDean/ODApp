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
    self.nickLabel.textColor = [UIColor colorWithRGBString:@"#484848" alpha:1];
    self.signLabel.textColor = [UIColor colorWithRGBString:@"#d0d0d0" alpha:1];
}

-(void)setModel:(ODBazaarDetailApplysModel *)model{
    __weakSelf
    [self.imageV sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        // 设置圆角
        [weakSelf.imageV setImage:[image OD_circleImage]];
    }];
    self.nickLabel.text = model.user_nick;
    self.signLabel.text = model.sign;
}

@end
