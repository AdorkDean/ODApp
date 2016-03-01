//
//  ODLandFirstCell.h
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODUserModel.h"

@interface ODLandFirstCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property(weak, nonatomic) IBOutlet UIImageView *userImageView;
@property(weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@property(nonatomic, strong) ODUser *model;

@end
