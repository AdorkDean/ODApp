//
//  ODMyOrderRecordCell.h
//  ODApp
//
//  Created by 代征钏 on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODMyOrderrecordModel.h"

@interface ODMyOrderRecordCell : UICollectionViewCell


- (void)showDatawithModel:(ODMyOrderRecordModel *)model;


@property (weak, nonatomic) IBOutlet UIImageView *centerNameImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerNameDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *beginTimeImageView;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *endTimeImageView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkStateLabel;


@end
