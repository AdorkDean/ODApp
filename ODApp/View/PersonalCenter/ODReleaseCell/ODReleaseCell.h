//
//  ODReleaseCell.h
//  ODApp
//
//  Created by 代征钏 on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODReleaseModel.h"
#import "UIImageView+WebCache.h"
#import "ODPersonalTaskButton.h"

@class ODPersonalTaskButton;

@interface ODReleaseCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *illegalLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet ODPersonalTaskButton *editButton;
@property (weak, nonatomic) IBOutlet ODPersonalTaskButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *horizontalLineView;

@property (nonatomic, strong) UIImageView *halvingLineImageView;

@property (nonatomic, strong) ODReleaseModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;

@end
