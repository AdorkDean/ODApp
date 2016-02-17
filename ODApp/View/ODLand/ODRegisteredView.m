//
//  ODRegisteredView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODRegisteredView.h"

@implementation ODRegisteredView

+(instancetype)getView
{
    ODRegisteredView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODRegisteredView" owner:nil options:nil] firstObject];
    
    
   view.backgroundColor = [UIColor whiteColor];
   view.registereButton.layer.masksToBounds = YES;
   view.registereButton.layer.cornerRadius = 5;
   view.registereButton.layer.borderColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1].CGColor;
   view.registereButton.layer.borderWidth = 1;
   view.password.secureTextEntry = YES;
   view.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    view.password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
       

    return view;
    
}

@end
