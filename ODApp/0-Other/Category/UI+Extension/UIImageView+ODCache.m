//
//  UIImageView+ODCache.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "UIImageView+ODCache.h"

@implementation UIImageView (ODCache)

static NSString * const placeholderImg = @"placeholderImage";
static NSString * const roundPlaceholderImg = @"titlePlaceholderImage";
static NSString * const errorPlaceholder = @"errorplaceholderImage";

- (void)od_setImageWithURLString:(NSString *)URLString
{
    [self sd_setImageWithURL:[NSURL OD_URLWithString:URLString] placeholderImage:[UIImage imageNamed:placeholderImg]];
}

- (void)od_setRoundImageWithURLString:(NSString *)URLString
{
    [self sd_setImageWithURL:[NSURL OD_URLWithString:URLString] placeholderImage:[UIImage imageNamed:roundPlaceholderImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
        self.image = [image OD_circleImage];
    }];
}

- (void)od_setImageErrorWithURLString:(NSString *)URLString
{
    [self sd_setImageWithURL:[NSURL OD_URLWithString:URLString] placeholderImage:[UIImage imageNamed:placeholderImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.image = [UIImage imageNamed:errorPlaceholder];
        }
    }];
}

- (void)od_setImageWithURLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completerBlock
{
    [self sd_setImageWithURL:[NSURL OD_URLWithString:URLString] placeholderImage:[UIImage imageNamed:placeholderImg] completed:completerBlock];
}

- (void)od_loadCachedImage:(NSString *)urlString
{
    __weakSelf;
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    if (!cachedImage) {
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        
        [downloader downloadImageWithURL:[NSURL OD_URLWithString:urlString]
                                 options:0
                                progress:NULL
                               completed:
         ^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
             // 保存到磁盘
             [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES];
             // 显示图片
             if (image && finished) weakSelf.image = image;
         }];
    }
    // 直接从缓存中加载图片
    weakSelf.image = cachedImage;
}

@end
