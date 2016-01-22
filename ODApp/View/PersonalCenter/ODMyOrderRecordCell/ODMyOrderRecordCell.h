//
//  ODMyOrderRecordCell.h
//  ODApp
//
//  Created by 代征钏 on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODClassMethod.h"
#import "ODMyOrderrecordModel.h"

@interface ODMyOrderRecordCell : UICollectionViewCell


- (void)showDatawithModel:(ODMyOrderRecordModel *)model;


@property (weak, nonatomic) IBOutlet UIImageView *centerPurposeImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerPurposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerPurposeDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *centerNameImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerNameDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkStateLabel;


@end
