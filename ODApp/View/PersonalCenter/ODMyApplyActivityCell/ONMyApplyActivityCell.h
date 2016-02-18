//
//  ONMyApplyActivityCell.h
//  ODApp
//
//  Created by 代征钏 on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODMyApplyActivityModel.h"

#import "UIImageView+WebCache.h"

@interface ONMyApplyActivityCell : UICollectionViewCell


- (void)showDataWithModel:(ODMyApplyActivityModel *)model;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;


@end
