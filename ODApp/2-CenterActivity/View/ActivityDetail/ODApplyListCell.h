//
//  ODApplyListCell.h
//  ODApp
//
//  Created by Bracelet on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODLoveListModel.h"
#import "ODApplyModel.h"

@interface ODApplyListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderImageWidth;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property(nonatomic, strong) ODApplyModel *applyModel;
@property(nonatomic, strong) ODLoveListModel *model;

- (void)setWithApplyModel:(ODApplyModel *)model;

- (void)setWithLikeModel:(ODLoveListModel *)model;


@end
