//
//  ODBazaarExchangeSkillCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarExchangeSkillCollectionCell.h"

@implementation ODBazaarExchangeSkillCollectionCell

- (void)awakeFromNib {
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 24;
    self.titleLabel.textColor = [UIColor colorGloomyColor];
    self.priceLabel.textColor = [UIColor colorRedColor];
    self.nickLabel.textColor = [UIColor colorGraynessColor];
    self.contentLabel.textColor = [UIColor colorGloomyColor];
    self.loveLabel.textColor = [UIColor colorGraynessColor];
    self.shareLabel.textColor = [UIColor colorGraynessColor];
}

-(void)showDatasWithModel:(ODHomeInfoSwapModel *)model
{
    self.titleLabel.text = model.title;
    self.priceLabel.text = [[[[NSString stringWithFormat:@"%@",model.price] stringByAppendingString:@"元"] stringByAppendingString:@"/"]stringByAppendingString:model.unit];
    self.contentLabel.text = model.content;
    self.loveLabel.text = [NSString stringWithFormat:@"%d",model.love_num];
    self.shareLabel.text = [NSString stringWithFormat:@"%d",model.share_num];
    NSString *gender = [NSString stringWithFormat:@"%@",model.user[@"gender"]];
    if ([gender isEqualToString:@"2"]) {
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];
        self.genderImgWidthConstant.constant = 13;
    }else{
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
        self.genderImgWidthConstant.constant = 6;
    }
}

-(void)setModel:(ODBazaarExchangeSkillModel *)model{
    
    _model = model;
    [self.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    self.titleLabel.text = model.title;
    self.priceLabel.text = [[[[NSString stringWithFormat:@"%f",model.price] stringByAppendingString:@"元"] stringByAppendingString:@"/"]stringByAppendingString:model.unit];
    self.nickLabel.text = model.user.nick;
    self.contentLabel.text = model.content;
    self.loveLabel.text = [NSString stringWithFormat:@"%d",model.love_num];
    self.shareLabel.text = [NSString stringWithFormat:@"%d",model.share_num];
    if (model.user.gender == ODBazaarUserGenderTypeWoman) {
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];
        self.genderImgWidthConstant.constant = 13;
    }else{
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
        self.genderImgWidthConstant.constant = 6;
    }

}

- (CGFloat)height
{
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.shareLabel.frame) + 15;
}


@end
