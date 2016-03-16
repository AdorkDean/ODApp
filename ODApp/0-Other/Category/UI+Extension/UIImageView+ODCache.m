//
//  UIImageView+ODCache.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "UIImageView+ODCache.h"

@implementation UIImageView (ODCache)

- (void)od_setImageWithURLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completerBlock
{
    [self sd_setImageWithURL:[NSURL OD_URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:completerBlock];
}
@end
