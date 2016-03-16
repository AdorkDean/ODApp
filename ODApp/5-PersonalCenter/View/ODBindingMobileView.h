//
//  ODBindingMobileView.h
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODBindingMobileView : UIView

+ (instancetype)getView;

@property(weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property(weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property(weak, nonatomic) IBOutlet UIButton *getCodelButton;
@property(weak, nonatomic) IBOutlet UIButton *bindingButton;


@end
