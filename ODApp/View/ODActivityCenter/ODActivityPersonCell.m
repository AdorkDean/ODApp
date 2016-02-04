//
//  ODActivityPersonCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "Masonry.h"
#import "ODActivityPersonCell.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"

@interface ODActivityPersonCell ()

@property (weak, nonatomic) IBOutlet UIScrollView *headImgsView;

@end

@implementation ODActivityPersonCell

- (void)setActivePersons:(NSArray *)activePersons
{
    CGFloat imgVTBDistance = 12.5;
    CGFloat imgVWH = self.od_height / 2 - imgVTBDistance;
    for (NSInteger i = 0; i < activePersons.count; i++)
    {
        ODActivityDetailAppliesModel *model = activePersons[i];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((imgVWH + 10) * i, imgVTBDistance, imgVWH, imgVWH)];
        [imgV sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgV.image = [image OD_circleImage];
        }];
        [self.headImgsView addSubview:imgV];
    }
}

@end
