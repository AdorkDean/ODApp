//
//  CenterActivityCell.h
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterActivityCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ActivityImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toRightSpace;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;


@end
