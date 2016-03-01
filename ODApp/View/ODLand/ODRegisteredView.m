//
//  ODRegisteredView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODRegisteredView.h"
#import <Masonry.h>

@implementation ODRegisteredView

+(instancetype)getView
{
    ODRegisteredView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODRegisteredView" owner:nil options:nil] firstObject];
    
    
   view.backgroundColor = [UIColor whiteColor];
   view.registereButton.layer.masksToBounds = YES;
   view.registereButton.layer.cornerRadius = 5;
   view.registereButton.layer.borderColor = [UIColor colorWithHexString:@"#333333" alpha:1].CGColor;
   view.registereButton.layer.borderWidth = 0.5f;
   view.password.secureTextEntry = YES;
   view.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    view.password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [view.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    [view.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    [view.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];

    return view;
    
}

@end
