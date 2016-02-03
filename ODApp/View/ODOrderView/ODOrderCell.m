//
//  ODOrderCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderCell.h"
#import "UIImageView+WebCache.h"
@implementation ODOrderCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.userImgeView.layer.masksToBounds = YES;
    self.userImgeView.layer.cornerRadius = 25;
    self.userImgeView.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImgeView.layer.borderWidth = 1;

    
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setModel:(ODBazaarExchangeSkillModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    
    [self.userImgeView sd_setImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]]];
    self.nickLabel.text = model.user[@"nick"];
    self.orderTitle.text = model.title;
    self.orderPrice.text = [NSString stringWithFormat:@"%@元/%@" , model.price , model.unit];
    NSString *url = model.imgs_small[0][@"img_url"];
    [self.orderImageView sd_setImageWithURL:[NSURL OD_URLWithString:url]];

    
    
    
    
}




@end
