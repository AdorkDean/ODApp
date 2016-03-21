//
//  ODBazaarPhoto.m
//  ODApp
//
//  Created by 王振航 on 16/3/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPhoto.h"
#import "ODBazaarExchangeSkillModel.h"

#import <UIImageView+WebCache.h>

@implementation ODBazaarPhoto

- (void)setSmallModel:(ODBazaarExchangeSkillImgs_smallModel *)smallModel
{
    _smallModel = smallModel;
    
    __weakSelf;
    [self sd_setImageWithURL:[NSURL OD_URLWithString:smallModel.img_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [weakSelf setImage:[UIImage imageNamed:@"errorplaceholderImage"]];
        } else {
            [weakSelf setImage:image];
        }
    }];
}

@end
