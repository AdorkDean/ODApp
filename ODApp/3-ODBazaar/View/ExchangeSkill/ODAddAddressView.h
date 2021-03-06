//
//  ODAddAddressView.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODAddAddressView : UIView

@property(weak, nonatomic) IBOutlet UIButton *defaultButton;

@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *phoneTextField;


@property(weak, nonatomic) IBOutlet UITextView *addressTextView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoConstraint;



+ (instancetype)getView;


@end
