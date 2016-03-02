//
//  ODAddAddressView.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAddAddressView.h"

@implementation ODAddAddressView

- (void)awakeFromNib
{

    self.lineOneConstraint.constant = 0.5;
    self.lineTwoConstraint.constant = 0.5;
}



+(instancetype)getView
{
    ODAddAddressView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODAddAddressView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    view.addressTextView.scrollEnabled = YES;
    
    return view;
    
    
    
    
}
    
@end
