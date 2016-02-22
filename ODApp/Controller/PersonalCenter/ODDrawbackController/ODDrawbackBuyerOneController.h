//
//  ODDrawbackBuyerOneController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"

#import "ODAPIManager.h"

@interface ODDrawbackBuyerOneController : ODBaseViewController<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *drawbackMoneyLabel;

@property (nonatomic, assign) BOOL isSelectReason;
@property (nonatomic, assign) BOOL isRelease;
@property (nonatomic, assign) BOOL isService;
@property (nonatomic, assign) BOOL isDrawbackState;

@property (nonatomic, strong) UILabel *drawbackReasonLabel;
@property (nonatomic, strong) UIView *drawbackReasonContentView;
@property (nonatomic, strong) UILabel *drawbackReasonContentLabel;

@property (nonatomic, assign) BOOL isSelectedReasonOne;
@property (nonatomic, assign) BOOL isSelectedReasonTwo;
@property (nonatomic, assign) BOOL isSelectedReasonThree;
@property (nonatomic, assign) BOOL isSelectedReasonFour;
@property (nonatomic, assign) BOOL isSelectedReasonOther;

@property (nonatomic, strong) UIView *drawbackReasonLineView;

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

@property (nonatomic, strong) UILabel *drawbackStateLabel;
@property (nonatomic, strong) UIView *drawbackStateContentView;
@property (nonatomic, strong) UITextView *drawbackStateTextView;

@property (nonatomic, strong) UILabel *contactServiceLabel;
@property (nonatomic, strong) UIView *servicePhoneView;
@property (nonatomic, strong) UILabel *servicePhoneLabel;
@property (nonatomic, strong) UIButton *servicePhoneButton;

@property (nonatomic, strong) UIView *serviceTimeView;
@property (nonatomic, strong) UILabel *serviceTimeLabel;

@property (nonatomic, strong) UIButton *releaseButton;

@property (nonatomic, copy) NSString *servicePhone;
@property (nonatomic, copy) NSString *serviceTime;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, assign) float darwbackMoney;

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *drawbackReason;


@end
