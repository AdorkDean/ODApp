//
//  ODDrawbackBuyerOneController.h
//  ODApp
//
//  Created by Bracelet on 16/2/20.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"

#import "ODAPIManager.h"

#import "ODHelp.h"

@interface ODDrawbackBuyerOneController : ODBaseViewController <UITextViewDelegate>

// 退款原因样式 YES：选择原因
@property(nonatomic, assign) BOOL isSelectReason;

// 是否需要 拒绝原因 版块
@property(nonatomic, assign) BOOL isRefuseReason;

// 一开始是否显示 退款说明
@property(nonatomic, assign) BOOL isDrawbackState;

// 是否需要 联系客服 版块
@property(nonatomic, assign) BOOL isService;

// 是否需要 申请退款 按钮
@property(nonatomic, assign) BOOL isRelease;

// 是否需要 拒绝 与 接收 按钮
@property(nonatomic, assign) BOOL isRefuseAndReceive;

@property(nonatomic, copy) NSString *order_id;

/**
 *  退款标题
 */
@property(nonatomic, copy) NSString *drawbackTitle;

/**
 *  退款金额
 */
@property(nonatomic, copy) NSString *darwbackMoney;

/**
 *  退款原因
 */
@property(nonatomic, copy) NSString *drawbackReason;

/**
 *  退款说明
 */
@property(nonatomic, copy) NSString *drawbackState;

/**
 *  拒绝原因
 */
@property(nonatomic, copy) NSString *refuseReason;

/**
 *  客服电话
 */
@property(nonatomic, copy) NSString *servicePhone;

/**
 *  服务时间
 */
@property(nonatomic, copy) NSString *serviceTime;

/**
 *  服务or客服
 */
@property(nonatomic, copy) NSString *customerService;

/**
 *  底部按钮文字内容
 */
@property(nonatomic, copy) NSString *confirmButtonContent;


@end
