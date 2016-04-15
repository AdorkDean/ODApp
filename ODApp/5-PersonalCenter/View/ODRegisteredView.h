//
//  ODRegisteredView.h
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODRegisteredView : UIView


+ (instancetype)getView;

@property(weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property(weak, nonatomic) IBOutlet UITextField *verification;
@property(weak, nonatomic) IBOutlet UIButton *getVerification;
@property(weak, nonatomic) IBOutlet UITextField *password;
@property(weak, nonatomic) IBOutlet UIButton *seePassword;
@property(weak, nonatomic) IBOutlet UIButton *registereButton;
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;

@property(weak, nonatomic) IBOutlet UILabel *line1;
@property(weak, nonatomic) IBOutlet UILabel *line2;
@property(weak, nonatomic) IBOutlet UILabel *line3;

@end
