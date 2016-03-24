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
    view.reasonTextView.layer.borderColor = [UIColor colorWithRGBString:@"d9d9d9" alpha:1.0f].CGColor;
    view.reasonTextView.layer.borderWidth = 0.5;
    view.alpha = 0.95;
    
    
    view.submitButton.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
    view.submitButton.layer.masksToBounds = YES;
    view.submitButton.layer.cornerRadius = 5;
    view.submitButton.layer.borderColor = [UIColor clearColor].CGColor;
    view.submitButton.layer.borderWidth = 0.5;
    
    
    
    return view;
    
    
    
    
}

@end
