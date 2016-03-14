//
//  ODBazaarPhotosView.m
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarPhotosView.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarExchangeSkillModel.h"

#define ODPhotoWH ((KScreenWidth - 75 - ODPhotoMargin * 3) / 3)
#define ODPhotoMargin (17 / 2)
#define ODPhotoMaxCol(count) ((count == 4) ? 2 : 3)

@implementation ODBazaarPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    // 取出传入的数组长度
    NSUInteger count = photos.count;
    
    // 创建图片控件
    while (self.subviews.count < count) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
    }
    
    // 创建了足够的imageView
    for (NSUInteger i = 0; i < self.subviews.count; i++)
    {
        UIImageView *photoView = self.subviews[i];
        if (i < count) {
            ODBazaarExchangeSkillImgs_smallModel *model = self.photos[i];
            [photoView sd_setImageWithURL:[NSURL OD_URLWithString:model.img_url]
                         placeholderImage:nil];
            photoView.hidden = NO;
        } else {
            photoView.hidden = YES;
        }
    }
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger photosCount = self.photos.count;
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

@end
