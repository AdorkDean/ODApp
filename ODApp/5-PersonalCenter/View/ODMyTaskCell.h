//
//  ODMyTaskCell.h
//  ODApp
//
//  Created by Odong-YG on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarModel.h"
#import "UIButton+WebCache.h"

@interface ODMyTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *spaceView;

@property (nonatomic,strong)ODBazaarModel *model;

@end
