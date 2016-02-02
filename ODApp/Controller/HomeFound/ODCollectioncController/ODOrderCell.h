//
//  ODOrderCell.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODOrderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImgeView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;


@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UILabel *orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;

@end
