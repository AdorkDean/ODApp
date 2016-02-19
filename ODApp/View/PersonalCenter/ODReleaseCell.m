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
    
    
    
}

- (void)setModel:(ODReleaseModel *)model
{

    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs_small[0][@"img_url"]]];
    self.contentLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@",model.price,model.unit];
    self.lovesLabel.text = [NSString stringWithFormat:@"%@  收藏",model.love_num];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
}

@end
