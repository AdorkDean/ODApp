//
//  ODCommunityCollectionCell.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODCommunityModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"


@interface ODCommunityCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PicConstraintHeight;



-(void)showDateWithModel:(ODCommunityModel *)model;

@end
