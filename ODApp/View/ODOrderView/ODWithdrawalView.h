//
//  ODWithdrawalView.h
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODWithdrawalView : UIView


@property(weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property(weak, nonatomic) IBOutlet UILabel *lineLabel;


@property(weak, nonatomic) IBOutlet UITextView *payAddressTextView;

@property(weak, nonatomic) IBOutlet UILabel *prcieLabel;

@property(weak, nonatomic) IBOutlet UIButton *withdrawalButton;


+ (instancetype)getView;


@end
