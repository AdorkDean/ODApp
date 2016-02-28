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

#import "ODHelp.h"

@interface ODDrawbackBuyerOneController : ODBaseViewController<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

// 退款原因样式 YES：选择原因
@property (nonatomic, assign) BOOL isSelectReason;

// 是否需要 拒绝原因 版块
@property (nonatomic, assign) BOOL isRefuseReason;

// 一开始是否显示 退款说明
@property (nonatomic, assign) BOOL isDrawbackState;

// 是否需要 联系客服 版块
@property (nonatomic, assign) BOOL isService;

// 是否需要 发布 按钮
@property (nonatomic, assign) BOOL isRelease;

// 是否需要 拒绝 与 接收 按钮
@property (nonatomic, assign) BOOL isRefuseAndReceive;


// 退款原因选择
@property (nonatomic, assign) BOOL isSelectedReasonOne;
@property (nonatomic, assign) BOOL isSelectedReasonTwo;
@property (nonatomic, assign) BOOL isSelectedReasonThree;
@property (nonatomic, assign) BOOL isSelectedReasonFour;
@property (nonatomic, assign) BOOL isSelectedReasonOther;

// 退款金额
@property (nonatomic, strong) UILabel *drawbackMoneyLabel;

// 退款原因
@property (nonatomic, strong) UILabel *drawbackReasonLabel;
@property (nonatomic, strong) UIView *drawbackReasonContentView;
@property (nonatomic, strong) UILabel *drawbackReasonContentLabel;

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

// 拒绝原因
@property (nonatomic, strong) UILabel *refuseReasonLabel;
@property (nonatomic, strong) UIView *refuseReasonContentView;
@property (nonatomic, strong) UILabel *refuseReasonContentLabel;


// 退款说明
@property (nonatomic, strong) UIView *drawbackStateView;
@property (nonatomic, strong) UILabel *drawbackStateLabel;
@property (nonatomic, strong) UIView *drawbackStateContentView;
@property (nonatomic, strong) UITextView *drawbackStateTextView;
@property (nonatomic, strong) UILabel *contentPlaceholderLabel;

// 联系客服
@property (nonatomic, strong) UILabel *contactServiceLabel;
@property (nonatomic, strong) UIView *servicePhoneView;

@property (nonatomic, strong) UILabel *servicePhoneLabel;
@property (nonatomic, strong) UIButton *servicePhoneButton;

@property (nonatomic, strong) UIView *serviceTimeView;
@property (nonatomic, strong) UILabel *serviceTimeLabel;

// 底部按钮
@property (nonatomic, strong) UIButton *releaseButton;

@property (nonatomic, strong) UIButton *refuseButton;
@property (nonatomic, strong) UIButton *receiveButton;


@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *managerRefuse;
@property (nonatomic, strong) AFHTTPRequestOperationManager *managerReceive;


@property (nonatomic, copy) NSString *order_id;

/**
 *  退款标题
 */
@property (nonatomic, copy) NSString *drawbackTitle;

/**
 *  退款金额
 */
@property (nonatomic, copy) NSString *darwbackMoney;

/**
 *  退款原因
 */
@property (nonatomic, copy) NSString *drawbackReason;

/**
 *  退款说明
 */
@property (nonatomic, copy) NSString *drawbackState;

/**
 *  拒绝原因
 */
@property (nonatomic, copy) NSString *refuseReason;

/**
 *  客服电话
 */
@property (nonatomic, copy) NSString *servicePhone;

/**
 *  服务时间
 */
@property (nonatomic, copy) NSString *serviceTime;

/**
 *  服务or客服
 */
@property (nonatomic, copy) NSString *customerService;

/**
 *  底部按钮文字内容
 */
@property (nonatomic, copy) NSString *confirmButtonContent;


@end
