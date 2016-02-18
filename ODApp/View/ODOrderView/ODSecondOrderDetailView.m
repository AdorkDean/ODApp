//
//  ODSecondOrderDetailView.m
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSecondOrderDetailView.h"

@implementation ODSecondOrderDetailView

+(instancetype)getView
{
    ODSecondOrderDetailView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODSecondOrderDetailView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    
    view.swapTypeLabel.layer.masksToBounds = YES;
    view.swapTypeLabel.layer.cornerRadius = 5;
    view.swapTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.swapTypeLabel.textColor = [UIColor lightGrayColor];
    view.swapTypeLabel.layer.borderWidth = 1;

    
    
    
    
    return view;
    
    
    
    
}

@end