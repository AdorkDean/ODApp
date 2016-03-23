//
//  ODBazaarPhotosView.m
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPhotosView.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODCommunityShowPicViewController.h"

#import "ODBazaarPhoto.h"

//#define ODPhotoMargin (17 / 2)
static CGFloat const ODPhotoMargin = 17 / 2;
//#define ODPhotoWH ((KScreenWidth - 75 - ODPhotoMargin * 3) / 3)
#define ODPhotoMaxCol(count) ((count == 4) ? 2 : 3)

@implementation ODBazaarPhotosView

#pragma mark - 初始化方法

- (void)awakeFromNib
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setSkillModel:(ODBazaarExchangeSkillModel *)skillModel
{
    _skillModel = skillModel;
    
    // 取出img_small数组长度
    NSArray *img_small = skillModel.imgs_small;
    NSUInteger count = img_small.count;
    
    // 创建图片控件
    while (self.subviews.count < count)
    {
        ODBazaarPhoto *photoView = [[ODBazaarPhoto alloc] init];
        [self addSubview:photoView];
    }
    
    for (NSUInteger i = 0; i < self.subviews.count; i++)
    {
        ODBazaarPhoto *photoView = self.subviews[i];
        if (i < count) {
            photoView.hidden = NO;
            photoView.smallModel = img_small[i];
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
    CGFloat ODPhotoWH = ((KScreenWidth - 75 - ODPhotoMargin * 3) / 3);
    
    NSUInteger photosCount = self.skillModel.imgs_small.count;
    
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
    CGFloat ODPhotoWH = ((KScreenWidth - 75 - ODPhotoMargin * 3) / 3);
    NSInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat photosW = cols * ODPhotoWH + (cols - 1) * ODPhotoMargin;
    
    // 行数
    NSInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * ODPhotoWH + (rows - 1) * ODPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

#pragma mark - 事件方法
/**
 *  点击图片
 */
- (void)clickPhotoView:(UITapGestureRecognizer *)gesture
{
    ODBazaarPhoto *photo = (ODBazaarPhoto *)gesture.view;
    
    ODBazaarExchangeSkillModel *model = self.skillModel;
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs_big;
    // 取出图片对应的位置
    picController.selectedIndex = [model.imgs_small indexOfObject:photo.smallModel];
    picController.skill = @"skill";
    
    UITabBarController *tabBarControler = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    [navigationController.topViewController presentViewController:picController animated:YES completion:nil];
}

@end
