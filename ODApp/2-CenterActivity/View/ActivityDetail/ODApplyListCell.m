//
//  ODApplyListCell.m
//  ODApp
//
//  Created by Bracelet on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODApplyListCell.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODLoveListModel.h"

@implementation ODApplyListCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.imageButton.layer.masksToBounds = YES;
    self.imageButton.layer.cornerRadius = 24;
    self.imageButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageButton.layer.borderWidth = 1;
    
    
}

-(void)setWithLikeModel:(ODLoveListModel *)model
{
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    self.schoolNameLabel.text = model.school_name;
    self.signLabel.text = model.nick;
    self.imageButton.userInteractionEnabled = NO;
    NSString *gender = [NSString stringWithFormat:@"%@", model.gender];
    if ([gender isEqualToString:@"2"]) {
        self.genderImageWidth.constant = 13;
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];
    }else{
        self.genderImageWidth.constant = 6;
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
    }
}



-(void)setWithApplyModel:(ODApplyModel *)model
{
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    self.schoolNameLabel.text = model.nick;
    self.signLabel.text = model.sign;
    self.imageButton.userInteractionEnabled = NO;
    NSString *gender = [NSString stringWithFormat:@"%@" , model.gender];
    if ([gender isEqualToString:@"2"]) {
        self.genderImageWidth.constant = 13;
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];        
    }else{
        self.genderImageWidth.constant = 6;
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
    }
}


@end
