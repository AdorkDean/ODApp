//
//  ODlandingView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODlandingView.h"

@implementation ODlandingView

+(instancetype)getView
{
   ODlandingView *view = [[[NSBundle mainBundle] loadNibNamed:@"ODlandingView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    view.accountLabel.layer.masksToBounds = YES;
    view.accountLabel.layer.cornerRadius = 20;
    view.accountLabel.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    view.accountLabel.layer.borderWidth = 1;
    
    view.passwordLabel.layer.masksToBounds = YES;
    view.passwordLabel.layer.cornerRadius = 20;
    view.passwordLabel.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    view.passwordLabel.layer.borderWidth = 1;
    
    view.landButton.layer.masksToBounds = YES;
    view.landButton.layer.cornerRadius = 20;
    view.landButton.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    view.landButton.layer.borderWidth = 1;
    view.landButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    
    view.passwordTextField.secureTextEntry = YES;
    
    
    return view;
    
}

@end
