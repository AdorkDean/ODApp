//
//  ODBalanceView.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBalanceView.h"

@implementation ODBalanceView

+(instancetype)getView
{
    ODBalanceView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODBalanceView" owner:nil options:nil] firstObject];
    
    view.backgroundColor = [UIColor backgroundColor];

    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor lineColor];
    view.withdrawalButton.backgroundColor = [UIColor colorRedColor];
    
  
    view.balanceImageView.layer.masksToBounds = YES;
    view.balanceImageView.layer.cornerRadius = 50;
    view.balanceImageView.layer.borderColor = [UIColor clearColor].CGColor;
    view.balanceImageView.layer.borderWidth = 1;
    view.balanceImageView.backgroundColor = [UIColor redColor];

    
    view.withdrawalButton.layer.masksToBounds = YES;
    view.withdrawalButton.layer.cornerRadius = 5;
    view.withdrawalButton.layer.borderColor = [UIColor clearColor].CGColor;
    view.withdrawalButton.layer.borderWidth = 1;
  

    view.withdrawalDetailButton.layer.masksToBounds = YES;
    view.withdrawalDetailButton.layer.cornerRadius = 5;
    view.withdrawalDetailButton.layer.borderColor = [UIColor clearColor].CGColor;
    view.withdrawalDetailButton.layer.borderWidth = 1;

    
    
    return view;
    
    
    
    
}

@end
