//
//  ODReleaseView.m
//  ODApp
//
//  Created by Bracelet on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODReleaseView.h"

@implementation ODReleaseView

- (void)awakeFromNib {
    [self.contentView bringSubviewToFront:self.lineView];
    self.titleImageView.layer.cornerRadius = 7;
    self.titleImageView.layer.masksToBounds = YES;
    
//    self.horicontalLineViewHeight.constant = 0.5;
//    self.lineViewWidth.constant = 0.5;
    
    self.contentLabel.textColor = [UIColor blackColor];
    
    self.priceLabel.textColor = [UIColor colorRedColor];
    
    self.lovesLabel.textColor = [UIColor colorGloomyColor];
    
    self.illegalLabel.textColor = [UIColor colorRedColor];
    self.horizontalLineView.backgroundColor = [UIColor lineColor];
    self.buttonWidthConstraint.constant = KScreenWidth / 2;
}

- (void)setModel:(ODReleaseModel *)model
{
    
    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs_small[0][@"img_url"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
    self.contentLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@",model.price,model.unit];
    if ([model.love_num isEqualToString:@""]) {
        model.love_num = @"0";
    }
    self.lovesLabel.text = [NSString stringWithFormat:@"%@  收藏",model.love_num];
    self.deleteButton.tag = [model.swap_id integerValue];
    if ([[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"-1"]) {
        self.illegalLabel.text = @"违规";
        self.editButton.enabled = NO;
    }
    else{
        self.illegalLabel.text = @"";
        self.editButton.enabled = YES;
    }
}


@end
