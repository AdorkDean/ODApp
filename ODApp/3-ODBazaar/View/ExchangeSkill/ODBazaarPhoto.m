//
//  ODBazaarPhoto.m
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPhoto.h"
#import "ODBazaarExchangeSkillModel.h"
#import "UIImageView+WebCache.h"

@implementation ODBazaarPhoto

- (void)setPhoto:(ODBazaarExchangeSkillImgs_smallModel *)photo
{
    _photo = photo;
    // 下载图片
    [self sd_setImageWithURL:[NSURL OD_URLWithString:photo.img_url]
            placeholderImage:nil];
}

@end
