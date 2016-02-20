//
//  ODDrawbackBuyerController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"


@interface ODDrawbackBuyerController : ODBaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *drawbackMoneyLabel;

@property (nonatomic, strong) UILabel *drawbackReasonLabel;
@property (nonatomic, strong) UILabel *drawbackReasonOneLabel;
@property (nonatomic, strong) UILabel *drawbackReasonTwoLabel;
@property (nonatomic, strong) UILabel *drawbackReasonThreeLabel;
@property (nonatomic, strong) UILabel *drawbackReasonFourLabel;
@property (nonatomic, strong) UILabel *drawbackReasonOtherLabel;

@property (nonatomic, strong) UILabel *drawbackStateLabel;
@property (nonatomic, strong) UITextField *drawbackStateTextField;

@end
