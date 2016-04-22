//
//  ODSubmitView.m
//  ODApp
//
//  Created by Bracelet on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSubmitOrderView.h"
#import "UIImageView+WebCache.m"


@implementation ODSubmitOrderView

+ (instancetype)submitOrderView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 37.5 / 2;
    
}

- (void)setModel:(ODBazaarExchangeSkillDetailModel *)model {
    if (_model != model) {
        _model = model;
    }
    [self.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:[model.user valueForKeyPath:@"avater"]] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    self.userNameLabel.text = [model.user valueForKeyPath:@"nick"];
    
    [self.skillImageView sd_setImageWithURL:[NSURL OD_URLWithString:[model.imgs_small[0] valueForKeyPath:@"img_url"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"]options:SDWebImageRetryFailed];
    self.skillNameLabel.text = model.title;
    self.skillPriceLabel.text = [NSString stringWithFormat:@"%.2f元/%@", model.price, model.unit];
}

@end
