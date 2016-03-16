//
//  UIImageView+ODCache.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (ODCache)

/**
 *  设置网络图片
 */
- (void)od_setImageWithURLString:(NSString *)URLString;

/**
 *  设置圆形网络图片
 */
- (void)od_setRoundImageWithURLString:(NSString *)URLString;

/**
 *  设置网络图片带有失败图
 */
- (void)od_setImageErrorWithURLString:(NSString *)URLString;

/**
 *  设置下载完成后的事件
 */
- (void)od_setImageWithURLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completerBlock;


@end
