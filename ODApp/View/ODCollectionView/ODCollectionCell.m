//
//  ODCollectionCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCollectionCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODLoveListModel.h"

@implementation ODCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.userImageButton.layer.masksToBounds = YES;
    self.userImageButton.layer.cornerRadius = 24;
    self.userImageButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageButton.layer.borderWidth = 1;
    self.lineHeightConstraint.constant = 0.5f;
    
    
}

-(void)setWithLikeModel:(ODLoveListModel *)model
{
    
    [self.userImageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    self.schoolLabel.text = model.school_name;
    self.nameLabel.text = model.nick;
    self.userImageButton.userInteractionEnabled = NO;
    NSString *gender = [NSString stringWithFormat:@"%@", model.gender];
    if ([gender isEqualToString:@"2"]) {
         self.genderImageWith.constant = 13;
        self.hisPictureView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
         self.genderImageWith.constant = 6;
        self.hisPictureView.image = [UIImage imageNamed:@"icon_man"];
        
    }
    
    
    
}





-(void)setWithApplyModel:(ODApplyModel *)model
{
    
    [self.userImageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar_url] forState:UIControlStateNormal];
    self.schoolLabel.text = model.nick;
    self.nameLabel.text = model.sign;
    self.userImageButton.userInteractionEnabled = NO;
    NSString *gender = [NSString stringWithFormat:@"%@" , model.gender];
    if ([gender isEqualToString:@"2"]) {
         self.genderImageWith.constant = 13;
        self.hisPictureView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
         self.genderImageWith.constant = 6;
        self.hisPictureView.image = [UIImage imageNamed:@"icon_man"];
       
    }

    
    
}


@end
