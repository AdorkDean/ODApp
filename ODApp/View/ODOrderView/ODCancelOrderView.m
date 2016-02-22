//
//  ODCancelOrderView.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCancelOrderView.h"

@implementation ODCancelOrderView

+(instancetype)getView
{
    ODCancelOrderView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODCancelOrderView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    
    view.reasonTextView.layer.masksToBounds = YES;
    view.reasonTextView.layer.cornerRadius = 5;
    view.reasonTextView.layer.borderColor = [UIColor blackColor].CGColor;
    view.reasonTextView.layer.borderWidth = 1;

    
    
    view.alpha = 0.9;
    
   
    
    
    
    
    return view;
    
    
    
    
}

@end
