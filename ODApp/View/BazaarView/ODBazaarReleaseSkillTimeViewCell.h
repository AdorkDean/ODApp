//
//  ODBazaarReleaseSkillTimeViewCell.h
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODBazaarReleaseSkillTimeModel.h"

@interface ODBazaarReleaseSkillTimeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)showDataWithModel:(ODBazaarReleaseSkillTimeModel *)model;

@end
