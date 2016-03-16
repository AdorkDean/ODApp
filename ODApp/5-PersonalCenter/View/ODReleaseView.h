//
//  ODReleaseView.h
//  ODApp
//
//  Created by Bracelet on 16/3/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODReleaseModel.h"
#import "UIImageView+WebCache.h"
#import "ODPersonalTaskButton.h"

@class ODPersonalTaskButton;

@interface ODReleaseView : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(weak, nonatomic) IBOutlet UILabel *lovesLabel;
@property(weak, nonatomic) IBOutlet UILabel *illegalLabel;
@property(weak, nonatomic) IBOutlet UIView *lineView;

@property(weak, nonatomic) IBOutlet ODPersonalTaskButton *editButton;
@property(weak, nonatomic) IBOutlet ODPersonalTaskButton *deleteButton;

@property(weak, nonatomic) IBOutlet UIView *horizontalLineView;

@property(nonatomic, strong) UIImageView *halvingLineImageView;

@property(nonatomic, strong) ODReleaseModel *model;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;




@end
