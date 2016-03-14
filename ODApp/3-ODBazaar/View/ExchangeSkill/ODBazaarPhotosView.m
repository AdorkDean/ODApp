//
//  ODBazaarPhotosView.m
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPhotosView.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODBazaarPhoto.h"
#import "ODCommunityShowPicViewController.h"

#define ODPhotoWH ((KScreenWidth - 75 - ODPhotoMargin * 3) / 3)
#define ODPhotoMargin (17 / 2)
#define ODPhotoMaxCol(count) ((count == 4) ? 2 : 3)

@implementation ODBazaarPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.autoresizingMask = UIViewAutoresizingNone;
        
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)setPhotos:(ODBazaarExchangeSkillModel *)photos
{
    _photos = photos;
    
    // 取出小图数组长度
    NSUInteger count = photos.imgs_small.count;
    
    // 创建图片控件
    while (self.subviews.count < count) {
        ODBazaarPhoto *photoView = [[ODBazaarPhoto alloc] init];
        [self addSubview:photoView];

    }
    
    // 创建了足够的imageView
    for (NSUInteger i = 0; i < self.subviews.count; i++)
    {
        ODBazaarPhoto *photoView = self.subviews[i];
        if (i < count) {
            // 传递数据
            photoView.photo = self.photos.imgs_small[i];
            photoView.hidden = NO;
        } else {
            photoView.hidden = YES;
        }
        
        // 添加点击手势
        photoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPhotoView:)];
        [photoView addGestureRecognizer:tap];
    }
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger photosCount = self.photos.imgs_small.count;
    NSInteger maxCol = ODPhotoMaxCol(photosCount);
    for (NSUInteger i = 0; i < photosCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        NSInteger col = i % maxCol;
        photoView.od_x = col * (ODPhotoWH + ODPhotoMargin);
        
        NSInteger row = i / maxCol;
        photoView.od_y = row * (ODPhotoWH + ODPhotoMargin);
        photoView.od_width = ODPhotoWH;
        photoView.od_height = ODPhotoWH;
    }
}

/**
 *  根据传入图片计算配图高度
 */
+ (CGSize)zh_sizeWithConnt:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    NSInteger maxCols = ODPhotoMaxCol(count);
    
    NSInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat photosW = cols * ODPhotoWH + (cols - 1) * ODPhotoMargin;
    
    // 行数
    NSInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * ODPhotoWH + (rows - 1) * ODPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

- (void)clickPhotoView:(ODBazaarPhoto *)photoView
{
    ODBazaarExchangeSkillModel *model = self.photos;
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs_big;
    // 取出图片对应的位置
    NSUInteger index = [self.subviews indexOfObject:photoView];
    
    picController.selectedIndex = index > 1000 ? 0 : index;
    picController.skill = @"skill";
    
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    [navigationController.topViewController presentViewController:picController animated:YES completion:nil];
}

@end
