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

- (void)od_setImageWithURLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completerBlock;

@end
