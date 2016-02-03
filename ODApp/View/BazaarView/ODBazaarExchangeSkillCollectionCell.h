//
//  ODBazaarExchangeSkillCollectionCell.h
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarExchangeSkillModel.h"

@interface ODBazaarExchangeSkillCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewConstraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintHeight;
-(void)showDatasWithModel:(ODBazaarExchangeSkillModel *)model;

@end
