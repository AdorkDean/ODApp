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
    self.headButton.layer.cornerRadius = 30;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.nickLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    self.loveLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.shareLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    
    
}

-(void)showDatasWithModel:(ODBazaarExchangeSkillModel *)model
{
    self.titleLabel.text = model.title;
    self.priceLabel.text = [[[NSString stringWithFormat:@"%@",model.price] stringByAppendingString:@"/"]stringByAppendingString:model.unit];
    self.contentLabel.text = model.content;
    self.loveLabel.text = [NSString stringWithFormat:@"%@",model.love_num];
    self.shareLabel.text = [NSString stringWithFormat:@"%@",model.share_num];
    NSString *gender = [NSString stringWithFormat:@"%@",model.user[@"gender"]];
    if ([gender isEqualToString:@"2"]) {
        self.genderImageView.image = [UIImage imageNamed:@"icon_woman"];
    }else{
        self.genderImageView.image = [UIImage imageNamed:@"icon_man"];
    }
}
@end
