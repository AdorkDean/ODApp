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
    view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];

    
    view.withdrawalButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];

    
    
    
    return view;
    
    
    
    
}

@end
