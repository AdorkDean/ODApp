//
//  ODlandingView.h
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODlandingView : UIView

+ (instancetype)getView;

@property(weak, nonatomic) IBOutlet UIView *accountLabel;
@property(weak, nonatomic) IBOutlet UITextField *accountTextField;
@property(weak, nonatomic) IBOutlet UIView *passwordLabel;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UIButton *landButton;
@property(weak, nonatomic) IBOutlet UIButton *forgetPassWordButton;


@end
