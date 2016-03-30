//
//  ODWithdrawalView.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODWithdrawalView.h"

@implementation ODWithdrawalView

+(instancetype)getView
{
    ODWithdrawalView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODWithdrawalView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor backgroundColor];
    view.coverImageView.backgroundColor = [UIColor lineColor];
    view.lineLabel.backgroundColor = [UIColor lineColor];

    
    view.withdrawalButton.backgroundColor = [UIColor colorRedColor];
    
    
    view.withdrawalButton.layer.masksToBounds = YES;
    view.withdrawalButton.layer.cornerRadius = 5;
    view.withdrawalButton.layer.borderColor = [UIColor clearColor].CGColor;
    view.withdrawalButton.layer.borderWidth = 1;
    
    
    
    
    return view;

}

@end
