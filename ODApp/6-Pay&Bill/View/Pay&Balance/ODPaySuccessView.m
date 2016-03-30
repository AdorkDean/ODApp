//
//  ODPaySuccessView.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPaySuccessView.h"

@implementation ODPaySuccessView

+(instancetype)getView
{
    ODPaySuccessView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODPaySuccessView" owner:nil options:nil] firstObject];
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    view.firstButton.layer.masksToBounds = YES;
    view.firstButton.layer.cornerRadius = 5;
    view.firstButton.layer.borderColor = [UIColor colorWithRGBString:@"#333333" alpha:1.0f].CGColor;
    view.firstButton.layer.borderWidth = 0.5f;
    
    view.secondButton.layer.masksToBounds = YES;
    view.secondButton.layer.cornerRadius = 5;
    view.secondButton.layer.borderColor = [UIColor colorWithRGBString:@"#333333" alpha:1.0f].CGColor;
    view.secondButton.layer.borderWidth = 0.5f;
    
    return view;
}

@end
