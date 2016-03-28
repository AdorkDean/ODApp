//
//  ODTakeOutBannerModel.h
//  ODApp
//
//  Created by 王振航 on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODTakeOutBannerModel : NSObject

/** 链接地址 */
@property (nonatomic, copy) NSString *banner_url;
/** 图片地址 */
@property (nonatomic, copy) NSString *img_url;
/** 标题 */
@property (nonatomic, copy) NSString *title;

@end
