//
//  ODOrderDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>

#import "UIButton+WebCache.h"

#import "ODOrderAndSellDetailController.h"
#import "ODDrawbackController.h"
#import "ODExchangePayViewController.h"

#import "ODOrderDetailModel.h"

#import "ODIndentDetailTopView.h"
#import "ODIndentDetailView.h"
#import "ODCancelOrderView.h"
#import "ODEvaluation.h"
#import <MJRefresh.h>

// label 统一高度
static CGFloat labelHeight = 40;

@interface ODOrderAndSellDetailController () <UITextViewDelegate>{
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

@property (nonatomic, strong) UIButton *endLeftButton;
@property (nonatomic, strong) UIButton *endRightButton;

@property (nonatomic, strong) ODOrderDetailModel *model;


@end

@implementation ODOrderAndSellDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    
    self.evaluateStar = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRequestData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - Create ScrollView

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, self.scrollHeight)];
    self.scrollView.backgroundColor = [UIColor backgroundColor];
    
    [self createTopView];
    [self createIndentDetailView];
    [self createBuyerInformationView];
    [self createOrderCancelReasonView];
    [self createDealTimeView];
    [self.view addSubview:self.scrollView];
}

#pragma mark - 底部是一个按钮
- (void)createEndisOneButton {

//    NSString *status = [NSString stringWithFormat:@"%@", self.model.order_status];
//    NSString *swapType = [NSString stringWithFormat:@"%@",self.model.swap_type];
    _endIsOneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _endIsOneButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
    _endIsOneButton.backgroundColor = [UIColor colorRedColor];
    _endIsOneButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [_endIsOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    if (self.isSellDetail) {
        if ([self.model.order_status isEqualToString:@"2"]) {
            [_endIsOneButton setTitle:@"确认发货" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.model.order_status isEqualToString:@"3"]) {
            [_endIsOneButton setTitle:@"确认服务" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.model.order_status isEqualToString:@"-2"]) {
            [_endIsOneButton setTitle:@"处理退款" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(dealDeliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.model.order_status isEqualToString:@"-3"] || [self.model.order_status isEqualToString:@"-4"] || [self.model.order_status isEqualToString:@"-5"]) {
            [_endIsOneButton setTitle:@"查看原因" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        if ([self.model.order_status isEqualToString:@"3"] || [self.model.order_status isEqualToString:@"2"]) {
            [_endIsOneButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([self.model.order_status isEqualToString:@"-5"] || [self.model.order_status isEqualToString:@"-3"] || [self.model.order_status isEqualToString:@"-4"]) {
            [_endIsOneButton setTitle:@"查看原因" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([self.model.order_status isEqualToString:@"5"] && [self.model.reason_num floatValue] == 0) {
            [_endIsOneButton setTitle:@"评价" forState:UIControlStateNormal];
            [_endIsOneButton addTarget:self action:@selector(evaluationAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.view addSubview:_endIsOneButton];
}

#pragma mark - 底部是两个按钮
- (void)createEndIsTwoButton {
    if (!self.isSellDetail) {
        ODOrderDetailModel *model = self.dataArray[0];
        NSString *status = [NSString stringWithFormat:@"%@", model.order_status];
        NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
        
        self.endLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.endLeftButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        self.endLeftButton.backgroundColor = [UIColor colorGrayColor];
        [self.endLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.endRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.endRightButton.frame = CGRectMake(KScreenWidth / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        self.endRightButton.backgroundColor = [UIColor colorGrayColor];
        [self.endRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.endLeftButton.backgroundColor = [UIColor colorGrayColor];
        self.endRightButton.backgroundColor = [UIColor colorRedColor];
        self.endLeftButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        self.endRightButton.titleLabel.font = [UIFont systemFontOfSize:12.5];

        if ([status isEqualToString:@"1"]){
            [self.endLeftButton setTitle:@"取消" forState:UIControlStateNormal];
            [self.endRightButton setTitle:@"立即支付" forState:UIControlStateNormal];
            [self.endLeftButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [self.endRightButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([status isEqualToString:@"4"]) {
            [self.endLeftButton setTitle:@"申请退款" forState:UIControlStateNormal];
            if ([swap_type isEqualToString:@"2"]) {
                [self.endRightButton setTitle:@"确认收货" forState:UIControlStateNormal];
            }
            else {
                [self.endRightButton setTitle:@"确认服务" forState:UIControlStateNormal];
            }
            [self.endLeftButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.endRightButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        [self.view addSubview:self.endLeftButton];
        [self.view addSubview:self.endRightButton];
    }
}

#pragma mark - 交易状态
- (void)createTopView {
    ODIndentDetailTopView *detailTopView = [[ODIndentDetailTopView alloc] init];
    detailTopView = [ODIndentDetailTopView detailTopView];
    ODOrderDetailModel *model = self.dataArray[0];
    if (self.isSellDetail) {
        detailTopView.isSellDetail = YES;
    }
    [detailTopView setModel:model];
    detailTopView.frame = CGRectMake(0, 0, KScreenWidth, 44);
    [self.scrollView addSubview:detailTopView];
}

#pragma mark - 订单内容
- (void)createIndentDetailView {
    self.indentDetailView = [[ODIndentDetailView alloc] init];
    self.indentDetailView = [ODIndentDetailView detailView];
    ODOrderDetailModel *model = self.dataArray[0];
    [self.indentDetailView setModel:model];
    self.indentDetailView.frame = CGRectMake(0, 44 + 6, KScreenWidth, 196);
    [self.scrollView addSubview:self.indentDetailView];
    [self.indentDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 买家信息
- (void)createBuyerInformationView {
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];

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
        if ([swap_type isEqualToString:@"3"]) {
            buyerName = [NSString stringWithFormat:@"联系人：%@", model.order_user[@"nick"]];
            buyerTel = [NSString stringWithFormat:@"联系方式：%@", model.order_user[@"mobile"]];
        }
        else {
            buyerName = [NSString stringWithFormat:@"联系人：%@", model.name];
            buyerTel = [NSString stringWithFormat:@"联系方式：%@", model.tel];
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

#pragma mark - 订单取消原因
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
                    orderReasonContentLabel.text = model.reason;
        if (!model.reason.length) {
            orderReasonContentLabel.text = @"无";
        }
        orderReasonContentLabel.numberOfLines = 0;
        orderReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        orderReasonContentLabel.textColor = [UIColor colorGloomyColor];
        [self.orderCancelReasonView addSubview:orderReasonContentLabel];
        dealTimeY = CGRectGetMaxY(self.orderCancelReasonView.frame);
    }
}

#pragma mark - 交易时间
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

#pragma mark - 评价
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
        weakSelf.evaluateStar = [NSString stringWithFormat:@"%ld", (long)tag - 1000];
        weakSelf.evaluationView.titleLabel.text = evaluationArray[tag - 1001];
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.evaluationView];
}

#pragma mark - Load Data Request
- (void)getRequestData {
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
         
         self.model = weakSelf.dataArray[0];
         if (([self.model.order_status isEqualToString:@"1"] || [self.model.order_status isEqualToString:@"4"])) {
             if (self.isSellDetail) {
                 self.scrollHeight = KControllerHeight - ODNavigationHeight;
             }
             else {
                 self.scrollHeight = KControllerHeight - ODNavigationHeight - 50;
             }
             [weakSelf createEndIsTwoButton];
         }
         else if ([self.model.order_status isEqualToString:@"-2"] && self.isSellDetail){
             self.scrollHeight = KControllerHeight - ODNavigationHeight - 50;
             [weakSelf createEndisOneButton];
         }
         else if ([self.model.order_status isEqualToString:@"2"] ||
                  [self.model.order_status isEqualToString:@"3"] ||
                  ([self.model.order_status isEqualToString:@"5"] && [self.model.reason_num floatValue] == 0) ||
                  [self.model.order_status isEqualToString:@"-3"] ||
                  [self.model.order_status isEqualToString:@"-4"] ||
                  [self.model.order_status isEqualToString:@"-5"]) {
             self.scrollHeight = KControllerHeight - ODNavigationHeight - 50;
             [weakSelf createEndisOneButton];
         }
         else {
             self.scrollHeight = KControllerHeight - ODNavigationHeight;
         }
         [weakSelf createScrollView];
     } failure:^(NSError *error) {
         [ODProgressHUD showInfoWithStatus:@"网络异常"];
     }];
}

#pragma mark - UITextView Delegate

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

#pragma mark - Action

#pragma mark - 确认发货
- (void)deliveryAction:(UIButton *)sender {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.order_id;
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapConfirmDelivery parameters:params modelClass:[NSObject class] success:^(id model) {
         [ODProgressHUD showInfoWithStatus:@"操作成功"];
         [weakSelf getRequestData];
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - 处理退款
- (void)dealDeliveryAction:(UIButton *)sender {    
    ODDrawbackController *vc = [[ODDrawbackController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.order_id;
    vc.drawbackReason = model.reason;
    vc.isRefuseAndReceive = YES;
    vc.drawbackTitle = @"退款处理";
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 取消订单
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
            [weakSelf getRequestData];
        } failure:^(NSError *error) {
            [ODProgressHUD showInfoWithStatus:@"网络异常"];
        }];
    }
}

#pragma mark - 查看原因
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

#pragma mark - 确认完成
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

#pragma mark - 评价
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
         [weakSelf getRequestData];
     } failure:^(NSError *error) {
         
     }];
}

- (void)evaluationAction:(UIButton *)sender {
    [self createEvaluation];
}

#pragma mark - 申请退款
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

#pragma mark - 取消订单
- (void)cancelOrder:(UIButton *)sender {
    self.cancelOrderView = [ODCancelOrderView getView];
    self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelOrderView.reasonTextView.delegate = self;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.cancelOrderView];
}

#pragma mark - 支付订单
- (void)payOrder:(UIButton *)sender {
    ODExchangePayViewController *vc = [[ODExchangePayViewController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.orderId = [NSString stringWithFormat:@"%@", model.order_id];
    vc.OrderTitle = model.title;
    vc.price = [NSString stringWithFormat:@"%@", model.total_price];
    vc.swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelEvaluation:(UIButton *)sender {
    [self.evaluationView removeFromSuperview];
}

- (void)cancelView:(UIButton *)sender {
    [self.cancelOrderView removeFromSuperview];
}

#pragma mark - 返回刷新
- (void)backAction:(UIBarButtonItem *)sender {
    NSDictionary *statusDict =[[NSDictionary alloc] initWithObjectsAndKeys:self.model.order_status,@"order_status", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationOrderListRefresh object:nil userInfo:statusDict];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 打电话
- (void)phoneAction:(UIButton *)sender {
    ODOrderDetailModel *model = self.dataArray[0];
    if (self.isSellDetail) {
        if ([model.swap_type isEqualToString:@"3"]) {
            [self.view callToNum:model.order_user[@"mobile"]];
        }
        else {
            [self.view callToNum:model.tel];
        }
    }
    else {
        [self.view callToNum:model.user[@"mobile"]];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
