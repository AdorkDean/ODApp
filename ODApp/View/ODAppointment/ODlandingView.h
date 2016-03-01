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

@property(weak, nonatomic) IBOutlet UILabel *accountLabel;
@property(weak, nonatomic) IBOutlet UITextField *accountTextField;
@property(weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UIButton *landButton;
@property(weak, nonatomic) IBOutlet UIButton *forgetPassWordButton;


@end
