//
//  ODNewFeatureCell.h
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODNewFeatureCell : UICollectionViewCell

/** 引导页图片 */
@property (nonatomic, weak) UIImage *image;

- (void)setIndex:(NSIndexPath *)indexPath imageCount:(NSInteger)count;

@end
