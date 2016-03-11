//
//  ODCommunityDetailCell.h
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODCommunityDetailModel.h"
#import "UIButton+WebCache.h"

@interface ODCommunityDetailCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIButton *headButton;
@property(weak, nonatomic) IBOutlet UILabel *nickName;
@property(weak, nonatomic) IBOutlet UIButton *replyButton;
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageViewConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelSpace;
@property(assign, nonatomic) CGFloat timeLabelSpaceConstant;

@property(nonatomic,strong)ODCommunityDetailModel *model;

@end
