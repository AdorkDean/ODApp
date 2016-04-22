//
//  ODActivePersonInfoView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"
#import "ODActivePersonInfoView.h"

@implementation ODActivePersonInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *rightIMGV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Skills profile page_icon_arrow_upper"]];
        rightIMGV.center = CGPointMake(KScreenWidth - ODLeftMargin * 2 - rightIMGV.od_width, 75 / 4);
        [self addSubview:rightIMGV];
    }
    return self;
}

- (UIScrollView *)headImgsView
{
    if (!_headImgsView)
    {
        _headImgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - ODLeftMargin * 2, 50)];
        [self addSubview:_headImgsView];
        _headImgsView.userInteractionEnabled = NO;
        _headImgsView.scrollEnabled = NO;
    }
    return _headImgsView;
}

- (void)setActivePersons:(NSArray *)activePersons
{
    CGFloat imgVTBDistance = 0;
    CGFloat imgVWH = 75 / 2;
    for (NSInteger i = 0; i < activePersons.count && (imgVWH + 10) * (i + 1) < self.od_width; i++)
    {
        ODActivityDetailAppliesModel *model = activePersons[i];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((imgVWH + 10) * i, imgVTBDistance, imgVWH, imgVWH)];
        [imgV sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgV.image = [image OD_circleImage];
        }];
        [self.headImgsView addSubview:imgV];
    }
}

@end
