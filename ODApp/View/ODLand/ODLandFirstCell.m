//
//  ODLandFirstCell.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODLandFirstCell.h"
#import "UIImageView+WebCache.h"

@implementation ODLandFirstCell

- (void)awakeFromNib {
    // Initialization code


    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 29;
    self.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageView.layer.borderWidth = 1;


}


- (void)setModel:(ODUserModel *)model {
    if (_model != model) {
        _model = model;
    }


    [self.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar]];
    self.qrcodeImageView.image = [UIImage imageNamed:@"qrcode_img"];


    if ([model.nick isEqualToString:@""]) {
        self.nickNameLabel.text = [NSString stringWithFormat:@"您还未设置昵称"];
    } else {
        self.nickNameLabel.text = model.nick;

    }

    if ([model.sign isEqualToString:@""]) {
        self.signatureLabel.text = [NSString stringWithFormat:@"您还未设置签名"];
    } else {
        self.signatureLabel.text = model.sign;

    }


}


@end
