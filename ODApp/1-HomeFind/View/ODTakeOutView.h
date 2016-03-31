//
//  ODTakeOutView.h
//  ODApp
//
//  Created by Bracelet on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODMyTakeOutModel.h"

@interface ODTakeOutView : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *outletSignImageView;

@property (weak, nonatomic) IBOutlet UILabel *takeOutStatus;

@property (weak, nonatomic) IBOutlet UILabel *takeOutName1;
@property (weak, nonatomic) IBOutlet UILabel *takeOutNumber1;

@property (weak, nonatomic) IBOutlet UILabel *takeOutTotalMoney;

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (weak, nonatomic) IBOutlet UIView *takeOutContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takeOutContentHeight;

//@property (nonatomic, strong) UILabel *takeOutNameLabel;
//@property (nonatomic, strong) UILabel *takeOutNumberLabel;

@property (nonatomic, strong) ODMyTakeOutModel *model;


@end
