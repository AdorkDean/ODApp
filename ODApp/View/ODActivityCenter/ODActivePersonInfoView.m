//
//  ODActivePersonInfoView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODActivityDetailModel.h"
#import "UIImageView+WebCache.h"
#import "ODActivePersonInfoView.h"

@implementation ODActivePersonInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        UIImageView *rightIMGV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Skills profile page_icon_arrow_upper"]];
        rightIMGV.center = CGPointMake(KScreenWidth - ODLeftMargin - rightIMGV.od_width * 2, 75 / 4);
        [self addSubview:rightIMGV];
    }
    return self;
}

- (UIScrollView *)headImgsView
{
    if (!_headImgsView)
    {
        _headImgsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - ODLeftMargin, 50)];
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
    for (NSInteger i = 0; i < activePersons.count && activePersons.count <= 8; i++)
    {
        ODActivityDetailAppliesModel *model = activePersons[i];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((imgVWH + 10) * i, imgVTBDistance, imgVWH, imgVWH)];
        [imgV sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgV.image = [image OD_circleImage];
        }];
        [self.headImgsView addSubview:imgV];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    
}
@end
