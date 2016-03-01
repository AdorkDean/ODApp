//
//  CenterDetailCell.h
//  ODApp
//
//  Created by zhz on 15/12/28.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterActivityModel.h"

@interface CenterDetailCell : UITableViewCell


@property(weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property(weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *toRightSpace;

@property(nonatomic, strong) CenterActivityModel *model;


@end
