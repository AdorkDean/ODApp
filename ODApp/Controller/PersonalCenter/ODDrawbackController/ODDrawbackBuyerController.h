//
//  ODDrawbackBuyerController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"


@interface ODDrawbackBuyerController : ODBaseViewController<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *drawbackMoneyLabel;

@property (nonatomic, strong) UILabel *drawbackReasonLabel;
@property (nonatomic, strong) UILabel *drawbackReasonOneLabel;
@property (nonatomic, strong) UILabel *drawbackReasonTwoLabel;
@property (nonatomic, strong) UILabel *drawbackReasonThreeLabel;
@property (nonatomic, strong) UILabel *drawbackReasonFourLabel;
@property (nonatomic, strong) UILabel *drawbackReasonOtherLabel;

@property (nonatomic, strong) UIButton *drawbackReasonOneButton;
@property (nonatomic, strong) UIButton *drawbackReasonTwoButton;
@property (nonatomic, strong) UIButton *drawbackReasonThreeButton;
@property (nonatomic, strong) UIButton *drawbackReasonFourButton;
@property (nonatomic, strong) UIButton *drawbackReasonOtherButton;

@property (nonatomic, strong) UIView *placeView;

@property (nonatomic, strong) UILabel *drawbackStateLabel;
@property (nonatomic, strong) UITextView *drawbackStateTextView;
@property (nonatomic, strong) UILabel *contentPlaceholderLabel;


@end
