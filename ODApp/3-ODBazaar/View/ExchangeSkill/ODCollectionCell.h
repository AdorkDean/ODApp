//
//  ODCollectionCell.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODLoveListModel.h"
#import "ODApplyModel.h"

@interface ODCollectionCell : UICollectionViewCell


@property(weak, nonatomic) IBOutlet NSLayoutConstraint *genderImageWith;


@property(weak, nonatomic) IBOutlet UIButton *userImageButton;
@property(weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property(weak, nonatomic) IBOutlet UIImageView *hisPictureView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) ODApplyModel *applyModel;
@property(nonatomic, strong) ODLoveListModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

- (void)setWithApplyModel:(ODApplyModel *)model;

- (void)setWithLikeModel:(ODLoveListModel *)model;
@end
