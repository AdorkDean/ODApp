//
//  ODCollectionCell.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODLikeModel.h"
@interface ODCollectionCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hisPictureView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic , strong) ODLikeModel *model;

@end
