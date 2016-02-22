//
//  ODDrawbackBuyerOneController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODDrawbackBuyerOneController : ODBaseViewController<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *drawbackMoneyLabel;

@property (nonatomic, assign) float darwbackMoney;


@property (nonatomic, strong) UILabel *drawbackReasonLabel;
@property (nonatomic, strong) UIView *drawbackReasonContentView;
@property (nonatomic, strong) UILabel *drawbackReasonContentLabel;

@property (nonatomic, strong) UILabel *drawbackStateLabel;
@property (nonatomic, strong) UIView *drawbackStateContentView;
@property (nonatomic, strong) UITextView *drawbackStateTextView;


@property (nonatomic, strong) UILabel *contactServiceLabel;
@property (nonatomic, strong) UIView *servicePhoneView;
@property (nonatomic, strong) UILabel *servicePhoneLabel;
@property (nonatomic, strong) UIButton *servicePhoneButton;

@property (nonatomic, strong) UIView *serviceTimeView;
@property (nonatomic, strong) UILabel *serviceTimeLabel;


@end
