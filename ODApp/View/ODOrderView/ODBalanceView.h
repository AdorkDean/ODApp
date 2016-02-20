//
//  ODBalanceView.h
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODBalanceView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *withdrawalButton;

@property (weak, nonatomic) IBOutlet UIButton *withdrawalDetailButton;


+(instancetype)getView;

@end
