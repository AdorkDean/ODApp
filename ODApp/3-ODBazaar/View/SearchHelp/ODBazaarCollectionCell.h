//
//  ODBazaarCollectionCell.h
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "ODBazaarModel.h"
#import "ODBazaarRequestHelpModel.h"

@interface ODBazaarCollectionCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIButton *headButton;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *statusLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraint;

@property (nonatomic,strong) ODBazaarRequestHelpTasksModel *model;

@end
