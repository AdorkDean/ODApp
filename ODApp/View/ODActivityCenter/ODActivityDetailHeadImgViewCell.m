//
//  ODActivityDetailHeadImgViewCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "ODActivityDetailHeadImgViewCell.h"

@interface ODActivityDetailHeadImgViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation ODActivityDetailHeadImgViewCell

- (void)setHeadImgUrl:(NSString *)headImgUrl
{
    [self.headImageView sd_setImageWithURL:[NSURL OD_URLWithString:headImgUrl]];
}

@end
