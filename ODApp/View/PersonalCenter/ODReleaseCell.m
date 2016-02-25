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
    
    self.titleImageView.layer.cornerRadius = 7;
    
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
    self.lovesLabel.font = [UIFont systemFontOfSize:14];
    self.lovesLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    
    self.editAndDeleteView.layer.borderWidth = 1;
    self.editAndDeleteView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    
    self.editButton = [ODPersonalTaskButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, KScreenWidth / 2, 43);
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.editButton setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setHighlighted:YES];
    [self.editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [self.editAndDeleteView addSubview:self.editButton];
    
    self.deleteButton = [ODPersonalTaskButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame =  CGRectMake(KScreenWidth / 2, 0, KScreenWidth / 2, 43);
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setHighlighted:YES];
    [self.deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [self.editAndDeleteView addSubview:self.deleteButton];

    self.halvingLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2 - 0.5, 15, 1, 13)];
    self.halvingLineImageView.image = [UIImage imageNamed:@"icon_separate"];
    [self.editAndDeleteView addSubview:self.halvingLineImageView];
}

- (void)setModel:(ODReleaseModel *)model
{

    [self.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs_small[0][@"img_url"]]];
    self.contentLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/%@",model.price,model.unit];
    self.lovesLabel.text = [NSString stringWithFormat:@"%@  收藏",model.love_num];
    self.deleteButton.tag = [model.swap_id integerValue];
}

@end
