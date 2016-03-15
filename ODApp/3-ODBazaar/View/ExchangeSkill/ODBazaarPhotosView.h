//
//  ODBazaarPhotosView.h
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODBazaarExchangeSkillModel;

@interface ODBazaarPhotosView : UIView

/** 配图数组 */
@property (nonatomic, strong) ODBazaarExchangeSkillModel *skillModel;

/**
 *  根据传入图片计算配图高度
 */
+ (CGSize)zh_sizeWithConnt:(NSUInteger)count;

@end
