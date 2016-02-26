//
//  ODReleaseCell.m
//  ODApp
//
//  Created by 代征钏 on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODReleaseCell.h"

@implementation ODReleaseCell

- (void)awakeFromNib {
    [self.contentView bringSubviewToFront:self.lineView];
    self.titleImageView.layer.cornerRadius = 7;
    self.titleImageView.layer.masksToBounds = YES;
    
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
    self.lovesLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    
    self.illegalLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.horizontalLineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.buttonWidthConstraint.constant = KScreenWidth / 2;
}

- (void)setModel:(ODReleaseModel *)model
{

    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs_small[0][@"img_url"]]];
    self.contentLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@",model.price,model.unit];
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
