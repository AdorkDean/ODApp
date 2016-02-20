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
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.withdrawalButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
  
    view.balanceImageView.layer.masksToBounds = YES;
    view.balanceImageView.layer.cornerRadius = 50;
    view.balanceImageView.layer.borderColor = [UIColor clearColor].CGColor;
    view.balanceImageView.layer.borderWidth = 1;
    view.balanceImageView.backgroundColor = [UIColor redColor];

    
    
    
    return view;
    
    
    
    
}

@end
