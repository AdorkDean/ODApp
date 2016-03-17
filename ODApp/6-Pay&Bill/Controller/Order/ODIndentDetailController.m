//
//  ODOrderDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>

#import "UIButton+WebCache.h"

#import "ODIndentDetailController.h"
#import "ODDrawbackController.h"
#import "ODPayController.h"

#import "ODOrderDetailModel.h"

#import "ODIndentDetailTopView.h"
#import "ODIndentDetailView.h"
#import "ODCancelOrderView.h"
#import "ODEvaluation.h"

@interface ODIndentDetailController () <UITextViewDelegate>{
    // label 统一高度
    float labelHeight;
    
    // dealTimeView 起始纵坐标
    float dealTimeY;
}

@property(nonatomic, copy) NSString *open_id;

// 数据数组
@property(nonatomic, strong) NSMutableArray *dataArray;

// 评价视图
@property(nonatomic, strong) ODEvaluation *evaluationView;

// 取消订单视图
@property(nonatomic, strong) ODCancelOrderView *cancelOrderView;

// 评价星级
@property(nonatomic, copy) NSString *evaluateStar;

// 评价满意程度
@property(nonatomic, copy) NSString *evaluateContent;

// 底层的UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView;

// UIScrollView 高度
@property (nonatomic, assign) long scrollHeight;

// 订单内容
@property (nonatomic, strong) ODIndentDetailView *indentDetailView;

// 买家信息
@property (nonatomic, strong) UIView *buyerView;

// 订单取消原因
@property (nonatomic, strong) UIView *orderCancelReasonView;

// 交易时间
@property (nonatomic, strong) UIView *dealTimeView;;

// 底部按钮
@property (nonatomic, strong) UIButton *endIsOneButton;
@property (nonatomic, strong) UIButton *endIsTwoButton;

@end

@implementation ODIndentDetailController

#pragma mark - 生命周期方法

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    
    self.evaluateStar = @"";
    //                [self createEvaluation];
    [self getData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, self.scrollHeight)];
        _scrollView.backgroundColor = [UIColor backgroundColor];
        
        [self createTopView];
        [self createIndentDetailView];
        [self createBuyerInformationView];
        [self createOrderCancelReasonView];
        [self createDealTimeView];
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIButton *)endIsOneButton {
    if (!_endIsOneButton) {
        NSString *status = [NSString stringWithFormat:@"%@", self.orderStatus];
        _endIsOneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _endIsOneButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        _endIsOneButton.backgroundColor = [UIColor colorRedColor];
        _endIsOneButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [_endIsOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([status isEqualToString:@"3"] || [status isEqualToString:@"2"]) {
            [_endIsOneButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([status isEqualToString:@"-5"] || [status isEqualToString:@"-3"] || [status isEqualToString:@"-4"]) {
            [_endIsOneButton setTitle:@"查看原因" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:_endIsOneButton];
    }
    return _endIsOneButton;
}

- (UIButton *)endIsTwoButton {
    if (!_endIsTwoButton) {
        ODOrderDetailModel *model = self.dataArray[0];
        NSString *status = [NSString stringWithFormat:@"%@", self.orderStatus];
        NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
        
        for (int i = 0; i < 2; i++) {
            _endIsTwoButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _endIsTwoButton.frame = CGRectMake(KScreenWidth / 2 * i, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
            _endIsTwoButton.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
            [_endIsTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ([status isEqualToString:@"1"]){
                NSArray *buttonTitleArray = @[ @"取消", @"立即支付" ];
                [_endIsTwoButton setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
                
                _endIsTwoButton.tag = 1000 + i;
                
                if (i == 0) {
                    _endIsTwoButton.backgroundColor = [UIColor colorGrayColor];
                }
                else {
                    _endIsTwoButton.backgroundColor = [UIColor colorRedColor];
                }
                
                [_endIsTwoButton addTarget:self action:@selector(cancelOrPayOrder:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([status isEqualToString:@"4"]) {
                if (i == 0) {
                    _endIsTwoButton.backgroundColor = [UIColor colorGrayColor];
                    [_endIsTwoButton setTitle:@"申请退款" forState:UIControlStateNormal];
                    [_endIsTwoButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                else {
                    _endIsTwoButton.backgroundColor = [UIColor colorRedColor];
                    if ([swap_type isEqualToString:@"2"]) {
                        [_endIsTwoButton setTitle:@"确认收货" forState:UIControlStateNormal];
                    }
                    else {
                        [_endIsTwoButton setTitle:@"确认服务" forState:UIControlStateNormal];
                    }
                    [_endIsTwoButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            _endIsTwoButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
            
            [self.view addSubview:_endIsTwoButton];
        }
    }
    return _endIsTwoButton;
}

// 交易状态
- (void)createTopView {
    ODIndentDetailTopView *detailTopView = [[ODIndentDetailTopView alloc] init];
    detailTopView = [ODIndentDetailTopView detailTopView];
    ODOrderDetailModel *model = self.dataArray[0];
    [detailTopView setModel:model];
    detailTopView.frame = CGRectMake(0, 0, KScreenWidth, 44);
    [self.scrollView addSubview:detailTopView];
}

// 订单内容
- (void)createIndentDetailView {
    self.indentDetailView = [[ODIndentDetailView alloc] init];
    self.indentDetailView = [ODIndentDetailView detailView];
    ODOrderDetailModel *model = self.dataArray[0];
    [self.indentDetailView setModel:model];
    self.indentDetailView.frame = CGRectMake(0, 44 + 6, KScreenWidth, 196);
    [self.scrollView addSubview:self.indentDetailView];
    [self.indentDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 买家信息
- (void)createBuyerInformationView {
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    
    labelHeight = 40;
    
    float addressHeight = [ODHelp textHeightFromTextString:[NSString stringWithFormat:@"服务地址：%@", model.address] width:KScreenWidth - ODLeftMargin * 2 - 13.5 * 5 miniHeight:labelHeight fontSize:13.5];
    
    // 动态设置 buyerInfoamtionView 的高度
    float buyerInformationViewHeight;
    if ([swap_type isEqualToString:@"1"]) {
        buyerInformationViewHeight = labelHeight * 4 + addressHeight;
    }
    else if ([swap_type isEqualToString:@"2"]) {
        buyerInformationViewHeight = labelHeight * 3 + addressHeight;
    }
    else {
        buyerInformationViewHeight = labelHeight * 4;
    }
    self.buyerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.indentDetailView.frame) + 6, KScreenWidth, buyerInformationViewHeight)];
    self.buyerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *buyerLabel;
    for (int i = 0; i < 3; i++) {
        NSString *buyerName;
        NSString *buyerTel;
        if ([swap_type isEqualToString:@"2"]) {
            buyerName = [NSString stringWithFormat:@"联系人：%@", model.name];
            buyerTel = [NSString stringWithFormat:@"联系方式：%@", model.tel];
        }
        else {
            buyerName = [NSString stringWithFormat:@"联系人：%@", model.order_user[@"nick"]];
            buyerTel = [NSString stringWithFormat:@"联系方式：%@", model.order_user[@"mobile"]];
        }

        NSArray *buyerArray = @[ @"买家信息", buyerName, buyerTel ];
        buyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, labelHeight * i, KScreenWidth - ODLeftMargin * 2, labelHeight)];
        buyerLabel.text = [NSString stringWithFormat:@"%@",buyerArray[i]];
        buyerLabel.font = [UIFont systemFontOfSize:13.5];
        if (i == 0) {
            buyerLabel.textColor = [UIColor blackColor];
        }
        else {
            buyerLabel.textColor = [UIColor colorGloomyColor];
        }
        
        [self.buyerView addSubview:buyerLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, labelHeight * (i + 1), KScreenWidth - ODLeftMargin, 0.5)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.buyerView addSubview:lineView];
    }
    
    if ([swap_type isEqualToString:@"1"] || [swap_type isEqualToString:@"2"]) {
        
        // 服务地址 Y
        float adressLabelY = CGRectGetMaxY(buyerLabel.frame);
        
        // 上门服务
        if ([swap_type isEqualToString:@"1"]) {
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(buyerLabel.frame) + 0.5, KScreenWidth - ODLeftMargin * 2, labelHeight)];
            timeLabel.text = [NSString stringWithFormat:@"服务时间：%@", model.service_time];
            timeLabel.textColor = [UIColor colorGloomyColor];
            timeLabel.font = [UIFont systemFontOfSize:13.5];
            [self.buyerView addSubview:timeLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(timeLabel.frame), KScreenWidth - ODLeftMargin, 0.5)];
            lineView.backgroundColor = [UIColor lineColor];
            [self.buyerView addSubview:lineView];
            
            adressLabelY = CGRectGetMaxY(lineView.frame);
        }
        // 快递服务
        UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, adressLabelY, 13.5 * 5, labelHeight)];
//        addressLabel.text = [NSString stringWithFormat:@"服务地址：%@",model.address];
        addressLabel.text = @"服务地址：";
        addressLabel.textColor = [UIColor colorGloomyColor];
        addressLabel.font = [UIFont systemFontOfSize:13.5];
        [self.buyerView addSubview:addressLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + 13.5 * 5, adressLabelY, KScreenWidth - ODLeftMargin * 2 - 13.5 * 5, addressHeight)];
        label.text = [NSString stringWithFormat:@"%@",model.address];
        label.textColor = [UIColor colorGloomyColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13.5];
        [self.buyerView addSubview:label];
        
        buyerInformationViewHeight = CGRectGetMaxY(addressLabel.frame);
    }
    // 线上服务
    else if ([swap_type isEqualToString:@"3"]) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(buyerLabel.frame) + 0.5, KScreenWidth - ODLeftMargin * 2, labelHeight)];
        timeLabel.text = [NSString stringWithFormat:@"服务时间：%@", model.service_time];
        timeLabel.textColor = [UIColor colorGloomyColor];
        timeLabel.font = [UIFont systemFontOfSize:13.5];
        [self.buyerView addSubview:timeLabel];
        buyerInformationViewHeight = CGRectGetMaxY(timeLabel.frame);
    }

    dealTimeY = CGRectGetMaxY(self.buyerView.frame);
    [self.scrollView addSubview:self.buyerView];
    
}

// 订单取消原因
- (void)createOrderCancelReasonView {
    ODOrderDetailModel *model = self.dataArray[0];
    if ([model.order_status isEqualToString:@"-1"]) {
        
        float reasonHeight;
        reasonHeight = [ODHelp textHeightFromTextString:model.reason width:KScreenWidth - ODLeftMargin * 2 miniHeight:40 fontSize:13.5];
        
        self.orderCancelReasonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buyerView.frame) + 6, KScreenWidth, labelHeight + reasonHeight + 0.5)];
        self.orderCancelReasonView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.orderCancelReasonView];
        
        UILabel *orderCancelReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth - ODLeftMargin * 2, labelHeight)];
        orderCancelReasonLabel.text = @"订单取消原因";
        orderCancelReasonLabel.font = [UIFont systemFontOfSize:13.5];
        orderCancelReasonLabel.textColor = [UIColor blackColor];
        [self.orderCancelReasonView addSubview:orderCancelReasonLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(orderCancelReasonLabel.frame), KScreenWidth - ODLeftMargin, 0.5)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.orderCancelReasonView addSubview:lineView];
        
        UILabel *orderReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(lineView.frame), KScreenWidth - ODLeftMargin * 2, reasonHeight)];
        if (!model.reason.length) {
            orderReasonContentLabel.text = @"无";
        }
        orderReasonContentLabel.text = model.reason;
        orderReasonContentLabel.numberOfLines = 0;
        orderReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        orderReasonContentLabel.textColor = [UIColor colorGloomyColor];
        [self.orderCancelReasonView addSubview:orderReasonContentLabel];
        dealTimeY = CGRectGetMaxY(self.orderCancelReasonView.frame);
    }
}

// 交易时间
- (void)createDealTimeView {
    ODOrderDetailModel *model = self.dataArray[0];

    self.dealTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, dealTimeY + 6, KScreenWidth, labelHeight * 3 + 1)];
    self.dealTimeView.backgroundColor = [UIColor whiteColor];
 
    NSString *orderNumber = [NSString stringWithFormat:@"订单编号：%@", model.order_id];
    NSString *orderTime = [NSString stringWithFormat:@"下单时间：%@", model.order_created_at];
    NSArray *dealArray = @[ @"交易时间", orderNumber, orderTime ];
    for (int i = 0; i < 3; i++) {
        UILabel * dealLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, (labelHeight + 0.5) * i, KScreenWidth - ODLeftMargin * 2, labelHeight)];
        dealLabel.text = dealArray[i];
        if (i == 0) {
            dealLabel.textColor = [UIColor blackColor];
        }
        else {
            dealLabel.textColor = [UIColor colorGloomyColor];
        }
        dealLabel.font = [UIFont systemFontOfSize:13.5];
        [self.dealTimeView addSubview:dealLabel];
    }
    for (int i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, labelHeight * i, KScreenWidth - ODLeftMargin, 0.5)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.dealTimeView addSubview:lineView];
    }
    self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(self.dealTimeView.frame));
    [self.scrollView addSubview:self.dealTimeView];
}

// 评价
- (void)createEvaluation {
    self.evaluationView = [[ODEvaluation alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.evaluationView.contentTextView.delegate = self;
    [self.evaluationView.cancelButton addTarget:self action:@selector(cancelEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.determineButton addTarget:self action:@selector(determineButton:) forControlEvents:UIControlEventTouchUpInside];
    __weakSelf
    self.evaluationView.starButtonTag = ^(NSInteger tag) {
        NSArray *starArray = @[ @"3K$7ZE(Z[0WTC}}}G8DR14P", @"3{1)]T1HQ%9R5HEQ$(3ZG0E" ];
        NSArray *evaluationArray = @[ @"非常不满意", @"不满意", @"一般", @"满意", @"非常满意" ];
        for (int i = 1; i < 6; i++) {
            if (i <= tag - 1000) {
                UIButton *button = (UIButton *)[weakSelf.evaluationView viewWithTag:i + 1000];
                [button setImage:[UIImage imageNamed:starArray[1]] forState:UIControlStateNormal];
            }
            else {
                UIButton *button = (UIButton *)[weakSelf.evaluationView viewWithTag:i + 1000];
                [button setImage:[UIImage imageNamed:starArray[0]] forState:UIControlStateNormal];
            }
        }
        weakSelf.evaluateStar = [NSString stringWithFormat:@"%ld", tag];
        weakSelf.evaluationView.titleLabel.text = evaluationArray[tag - 1001];
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.evaluationView];
}

#pragma mark - 获取数据
- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.order_id;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrderInfo parameters:params modelClass:[ODOrderDetailModel class] success:^(id model)
     {
         ODOrderDetailModel *detailModel = [model result];
         
         [weakSelf.dataArray removeAllObjects];
         [weakSelf.dataArray addObject:detailModel];
         
         ODOrderDetailModel *statusModel = weakSelf.dataArray[0];
         NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
         if (![self.orderStatus isEqualToString:orderStatue]) {
             NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
             NSNotification *notification = [NSNotification notificationWithName:ODNotificationMyOrderSecondRefresh object:nil userInfo:dic];
             [[NSNotificationCenter defaultCenter] postNotification:notification];
         }
         if ([weakSelf.orderStatus isEqualToString:@"1"] || [weakSelf.orderStatus isEqualToString:@"4"]) {
             self.scrollHeight = KScreenHeight - 64 - 50;
             [weakSelf endIsTwoButton];
         }
         else if ([weakSelf.orderStatus isEqualToString:@"2"] || [weakSelf.orderStatus isEqualToString:@"3"] || [weakSelf.orderStatus isEqualToString:@"-3"] || [weakSelf.orderStatus isEqualToString:@"-4"] || [weakSelf.orderStatus isEqualToString:@"-5"]) {
             self.scrollHeight = KScreenHeight - 64 - 50;
             [weakSelf endIsOneButton];
         }
         else{
             self.scrollHeight = KScreenHeight - 64;
         }
         [weakSelf scrollView];
     } failure:^(NSError *error) {
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

#pragma mark - UITextView 代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.cancelOrderView.reasonTextView) {
        if ([textView.text isEqualToString:@"请输入取消原因"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    else if (textView == self.evaluationView.contentTextView) {
        if ([textView.text isEqualToString:@"请输入评价内容"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.cancelOrderView.reasonTextView) {
        if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {
            self.cancelOrderView.reasonTextView.text = @"请输入取消原因";
            self.cancelOrderView.reasonTextView.textColor = [UIColor lightGrayColor];
        }
    }
    else if (textView == self.evaluationView.contentTextView) {
        if ([self.evaluationView.contentTextView.text isEqualToString:@"请输入评价内容"] || [self.evaluationView.contentTextView.text isEqualToString:@""]) {
            self.evaluationView.contentTextView.text = @"请输入评价内容";
            self.evaluationView.contentTextView.textColor = [UIColor lightGrayColor];
        }
    }
}

#pragma mark - 事件方法
- (void)submitAction:(UIButton *)sender {
    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {
        [ODProgressHUD showInfoWithStatus:@"请输入取消原因"];
    }
    else {
        // 拼接参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"order_id"] = self.order_id;
        params[@"reason"] = self.cancelOrderView.reasonTextView.text;
        params[@"open_id"] = self.open_id;
        __weakSelf
        // 发送请求
        [ODHttpTool getWithURL:ODUrlSwapOrderCancel parameters:params modelClass:[NSObject class] success:^(id model) {
            [weakSelf.cancelOrderView removeFromSuperview];
            [ODProgressHUD showInfoWithStatus:@"取消订单成功"];
            ODOrderDetailModel *statusModel = self.dataArray[0];
            weakSelf.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];
             
            if (weakSelf.getRefresh) {
                weakSelf.getRefresh(@"1");
            }
             
            [weakSelf getData];
        } failure:^(NSError *error) {
            [ODProgressHUD showInfoWithStatus:@"网络异常"];
        }];
    }
}

- (void)backAction:(UIBarButtonItem *)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRefrash:) name:ODNotificationMyOrderThirdRefresh object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backRefrash:(NSNotification *)text {
    ODOrderDetailModel *statusModel = self.dataArray[0];
    NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
    NSNotification *notification = [NSNotification notificationWithName:ODNotificationMyOrderSecondRefresh object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

// 查看原因
- (void)reasonAction:(UIButton *)sender {
    
    ODDrawbackController *vc = [[ODDrawbackController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.order_id;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    
    if ([model.reject_reason isEqualToString:@""]) {
        vc.isRefuseReason = NO;
    } else {
        vc.isRefuseReason = YES;
        vc.refuseReason = model.reject_reason;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// 确认完成
- (void)confirmAction:(UIButton *)sender {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.order_id;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapFinish parameters:params modelClass:[NSObject class] success:^(id model)
     {
         [weakSelf createEvaluation];
         
     } failure:^(NSError *error) {
         
     }];
}

- (void)determineButton:(UIButton *)sender {
    if ([self.evaluationView.contentTextView.text isEqualToString:@""] || [self.evaluationView.contentTextView.text isEqualToString:@"请输入评价内容"]) {
        self.evaluateContent = @"";
    } else {
        self.evaluateContent = self.evaluationView.contentTextView.text;
    }
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.order_id;
    params[@"reason"] = self.evaluateContent;
    params[@"reason_num"] = self.evaluateStar;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrderReason parameters:params modelClass:[NSObject class] success:^(id model) {
         [weakSelf.evaluationView removeFromSuperview];
         [ODProgressHUD showInfoWithStatus:@"评价成功"];
         ODOrderDetailModel *statusModel = weakSelf.dataArray[0];
         weakSelf.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];
         
         if (weakSelf.getRefresh) {
             weakSelf.getRefresh(@"1");
         }
         [weakSelf getData];
     } failure:^(NSError *error) {
         
     }];
}

// 评价
- (void)evaluationAction:(UIButton *)sender {
    [self createEvaluation];
}

// 申请退款
- (void)refundAction:(UIButton *)sender {
    ODOrderDetailModel *model = self.dataArray[0];
    ODDrawbackController *vc = [[ODDrawbackController alloc] init];
    
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.order_id;
    vc.isSelectReason = YES;
    vc.isRelease = YES;
    vc.confirmButtonContent = @"申请退款";
    vc.drawbackTitle = @"申请退款";
    [self.navigationController pushViewController:vc animated:YES];
}

// 取消 或 支付订单
- (void)cancelOrPayOrder:(UIButton *)sender {
    if (sender.tag == 1000) {
        self.cancelOrderView = [ODCancelOrderView getView];
        self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelOrderView.reasonTextView.delegate = self;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.cancelOrderView];
    }
    else {
        ODPayController *vc = [[ODPayController alloc] init];
        ODOrderDetailModel *model = self.dataArray[0];
        vc.orderId = [NSString stringWithFormat:@"%@", model.order_id];
        vc.OrderTitle = model.title;
        vc.price = [NSString stringWithFormat:@"%@", model.total_price];
        vc.swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)cancelEvaluation:(UIButton *)sender {
    [self.evaluationView removeFromSuperview];
}

- (void)cancelView:(UIButton *)sender {
    [self.cancelOrderView removeFromSuperview];
}

// 打电话
- (void)phoneAction:(UIButton *)sender {
    ODOrderDetailModel *model = self.dataArray[0];
    NSMutableDictionary *dic = model.user;
    [self.view callToNum:dic[@"mobile"]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
