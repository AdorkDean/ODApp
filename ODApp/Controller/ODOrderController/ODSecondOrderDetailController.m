//
//  ODSecondOrderDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODSecondOrderDetailController.h"
#import "ODSecondOrderDetailView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"
#import "ODCancelOrderView.h"
#import "ODDrawbackBuyerOneController.h"
#import "ODEvaluation.h"

@interface ODSecondOrderDetailController () <UITextViewDelegate>


@property(nonatomic, strong) ODSecondOrderDetailView *orderDetailView;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property(nonatomic, strong) AFHTTPRequestOperationManager *delateManager;
@property(nonatomic, strong) AFHTTPRequestOperationManager *finishManager;
@property(nonatomic, strong) AFHTTPRequestOperationManager *evalueManager;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) ODEvaluation *evaluationView;
@property(nonatomic, strong) ODCancelOrderView *cancelOrderView;
@property(nonatomic, copy) NSString *evaluateStar;
@property(nonatomic, copy) NSString *evaluateContent;

@property(nonatomic, strong) UIScrollView *scroller;


@end

@implementation ODSecondOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.evaluateStar = @"";

    self.dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)getData {
    self.manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"order_id" : self.order_id, @"open_id" : self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

    __weak typeof(self) weakSelf = self;
    [self.manager GET:kOrderDetailUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {


            if ([responseObject[@"status"] isEqualToString:@"success"]) {


                [self.dataArray removeAllObjects];
                NSMutableDictionary *dic = responseObject[@"result"];
                ODOrderDetailModel *model = [[ODOrderDetailModel alloc] init];

                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];


                ODOrderDetailModel *statusModel = self.dataArray[0];
                NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];


                NSLog(@"_____%@", self.orderStatus);
                NSLog(@"______%@", orderStatue);


                if (![self.orderStatus isEqualToString:orderStatue]) {


                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
                    NSNotification *notification = [NSNotification notificationWithName:ODNotificationMyOrderSecondRefresh object:nil userInfo:dic];

                    [[NSNotificationCenter defaultCenter] postNotification:notification];

                }


            } else if ([responseObject[@"status"] isEqualToString:@"error"]) {


                [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];


            }


            [weakSelf createScroller];


        }
    }         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];


}

- (void)createScroller {

    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.scroller.userInteractionEnabled = YES;
    self.scroller.backgroundColor = [UIColor whiteColor];
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];

    if ([status isEqualToString:@"-1"]) {

        if (iPhone4_4S) {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 350);

        } else if (iPhone5_5s) {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 270);


        } else if (iPhone6_6s) {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 150);


        } else {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 100);

        }


    } else {


        if (iPhone4_4S) {
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 290);

        } else if (iPhone5_5s) {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 200);

        } else if (iPhone6_6s) {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 100);


        } else {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 30);


        }


    }


    [self.view addSubview:self.scroller];


    if ([status isEqualToString:@"3"] || [status isEqualToString:@"2"]) {

        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        refundButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];


    } else if ([status isEqualToString:@"1"]) {

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        cancelButton.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];

        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
        payButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        payButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payButton];


    } else if ([status isEqualToString:@"4"]) {

        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        refundButton.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];


        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [confirmButton setTitle:@"确认服务" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmButton];


    } else if ([status isEqualToString:@"-5"] || [status isEqualToString:@"-3"] || [status isEqualToString:@"-4"]) {


        UIButton *reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        reasonButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        reasonButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reasonButton];


    }

    [self createView];


}


// 查看原因
- (void)reasonAction:(UIButton *)sender {

    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.order_id;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    vc.refuseReason = model.reject_reason;

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

    self.finishManager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"order_id" : self.order_id, @"open_id" : self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

    [self.finishManager GET:kFinshOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {


            if ([responseObject[@"status"] isEqualToString:@"success"]) {


                [self createEvaluation];


            } else if ([responseObject[@"status"] isEqualToString:@"error"]) {


                [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];


            }


        }
    }               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];


}

// 创建评价界面
- (void)createEvaluation {

    self.evaluationView = [[ODEvaluation alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.evaluationView.contentTextView.delegate = self;
    [self.evaluationView.cancelButton addTarget:self action:@selector(cancelEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.determineButton addTarget:self action:@selector(determineButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.evaluationView.firstButton addTarget:self action:@selector(firstButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.secondButton addTarget:self action:@selector(secondButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.thirdButton addTarget:self action:@selector(thirdButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.fourthButton addTarget:self action:@selector(fourthButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.fiveButton addTarget:self action:@selector(fiveButtonClicik:) forControlEvents:UIControlEventTouchUpInside];

    [[[UIApplication sharedApplication] keyWindow] addSubview:self.evaluationView];


}

- (void)firstButtonClicik:(UIButton *)button {

    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"1";
    self.evaluationView.titleLabel.text = @"非常不满意";
}

- (void)secondButtonClicik:(UIButton *)button {

    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"2";
    self.evaluationView.titleLabel.text = @"不满意";

}

- (void)thirdButtonClicik:(UIButton *)button {

    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"3";
    self.evaluationView.titleLabel.text = @"一般";

}

- (void)fourthButtonClicik:(UIButton *)button {

    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"4";
    self.evaluationView.titleLabel.text = @"满意";

}

- (void)fiveButtonClicik:(UIButton *)button {

    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    self.evaluateStar = @"5";
    self.evaluationView.titleLabel.text = @"非常满意";

}


// 评价
- (void)determineButton:(UIButton *)sender {


    if ([self.evaluationView.contentTextView.text isEqualToString:@""] || [self.evaluationView.contentTextView.text isEqualToString:@"请输入评价内容"]) {

        self.evaluateContent = @"";

    } else {

        self.evaluateContent = self.evaluationView.contentTextView.text;
    }
    self.evalueManager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"order_id" : self.order_id, @"reason" : self.evaluateContent, @"reason_num" : self.evaluateStar, @"open_id" : self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

    __weak typeof(self) weakSelf = self;


    [self.evalueManager GET:kEvalueUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {


            if ([responseObject[@"status"] isEqualToString:@"success"]) {

                [weakSelf.evaluationView removeFromSuperview];


                [ODProgressHUD showInfoWithStatus:@"评价成功"];

                ODOrderDetailModel *statusModel = self.dataArray[0];
                weakSelf.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];
                if (self.getRefresh) {


                    weakSelf.getRefresh(@"1");
                }


                [weakSelf getData];


            } else if ([responseObject[@"status"] isEqualToString:@"error"]) {


                [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];


            }


        }
    }               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];


}


// 评价
- (void)evaluationAction:(UIButton *)sender {

    [self createEvaluation];
}

// 申请退款
- (void)refundAction:(UIButton *)sender {

    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.order_id;
    vc.isSelectReason = YES;
    vc.isRelease = YES;
    vc.confirmButtonContent = @"申请退款";
    vc.drawbackTitle = @"申请退款";
    [self.navigationController pushViewController:vc animated:YES];


}


// 取消订单
- (void)cancelOrder:(UIButton *)sender {
    self.cancelOrderView = [ODCancelOrderView getView];
    self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelOrderView.reasonTextView.delegate = self;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.cancelOrderView];

}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {


    if (textView == self.cancelOrderView.reasonTextView) {
        if ([textView.text isEqualToString:@"请输入取消原因"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }

    } else if (textView == self.evaluationView.contentTextView) {

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

    } else if (textView == self.evaluationView.contentTextView) {

        if ([self.evaluationView.contentTextView.text isEqualToString:@"请输入评价内容"] || [self.evaluationView.contentTextView.text isEqualToString:@""]) {
            self.evaluationView.contentTextView.text = @"请输入评价内容";
            self.evaluationView.contentTextView.textColor = [UIColor lightGrayColor];
        }


    }


}

- (void)submitAction:(UIButton *)sender {


    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {


        [ODProgressHUD showInfoWithStatus:@"请输入取消原因"];

    } else {


        self.delateManager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"order_id" : self.order_id, @"reason" : self.cancelOrderView.reasonTextView.text, @"open_id" : self.open_id};
        NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

        __weak typeof(self) weakSelf = self;
        [self.delateManager GET:kDelateOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if (responseObject) {


                if ([responseObject[@"status"] isEqualToString:@"success"]) {

                    [weakSelf.cancelOrderView removeFromSuperview];


                    [ODProgressHUD showInfoWithStatus:@"取消订单成功"];

                    ODOrderDetailModel *statusModel = self.dataArray[0];
                    weakSelf.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];

                    if (self.getRefresh) {


                        weakSelf.getRefresh(@"1");
                    }


                    [weakSelf getData];


                } else if ([responseObject[@"status"] isEqualToString:@"error"]) {


                    [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];


                }


            }
        }               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ODProgressHUD showInfoWithStatus:@"网络异常"];
        }];


    }


}


- (void)cancelEvaluation:(UIButton *)sender {
    [self.evaluationView removeFromSuperview];
}


- (void)cancelView:(UIButton *)sender {
    [self.cancelOrderView removeFromSuperview];
}


- (void)payAction:(UIButton *)sender {
    ODPayController *vc = [[ODPayController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.orderId = [NSString stringWithFormat:@"%@", model.order_id];
    vc.OrderTitle = model.title;
    vc.price = [NSString stringWithFormat:@"%@", model.total_price];
    vc.swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)createView {

    self.orderDetailView = [ODSecondOrderDetailView getView];
    self.orderDetailView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);

    ODOrderDetailModel *model = self.dataArray[0];
    NSMutableDictionary *dic = model.user;
    [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", dic[@"avatar"]]] forState:UIControlStateNormal];
    self.orderDetailView.nickLabel.text = dic[@"nick"];
    NSMutableArray *arr = model.imgs_small;
    NSMutableDictionary *picDic = arr[0];

    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];
    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];


    if ([status isEqualToString:@"-1"]) {


//        self.orderDetailView.spaceToTop.constant = 120;


        CGRect rect = [model.address boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 93, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                  context:nil];


        //订单取消原因
        UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(18, self.orderDetailView.spaceLabel.frame.origin.y + rect.size.height, 100, 20)];
        reason.backgroundColor = [UIColor whiteColor];
        reason.font = [UIFont systemFontOfSize:14];

        reason.text = @"订单取消原因";
        reason.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reason];

        UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(18, reason.frame.origin.y + 30, kScreenSize.width - 18, 1)];
        secondLine.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:secondLine];

        float reasonHeight;
        reasonHeight = [ODHelp textHeightFromTextString:model.reason width:KScreenWidth - 36 miniHeight:35 fontSize:14];
        
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, secondLine.frame.origin.y + 5, kScreenSize.width - 36, reasonHeight)];
        reasonLabel.backgroundColor = [UIColor whiteColor];
        reasonLabel.font = [UIFont systemFontOfSize:14];
        reasonLabel.numberOfLines = 0;
        reasonLabel.text = model.reason;
        reasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reasonLabel];


        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reasonLabel.frame), kScreenSize.width, 6)];
        line.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:line];

        self.orderDetailView.spaceToTop.constant = reasonHeight + 62;
    }


    [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", picDic[@"img_url"]]] forState:UIControlStateNormal];

    [self.orderDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];


    self.orderDetailView.contentLabel.text = model.title;
    self.orderDetailView.countLabel.text = [NSString stringWithFormat:@"%@", model.num];
    self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@", model.order_price, model.unit];
    self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元", model.total_price];

    self.orderDetailView.typeLabel.text = self.orderType;
    self.orderDetailView.addressNameLabel.text = model.name;
    self.orderDetailView.addressPhoneLabel.text = model.tel;


    self.orderDetailView.swapTypeLabel.text = @"上门服务";


    self.orderDetailView.serviceAddressLabel.text = model.address;
    self.orderDetailView.serviceTimeLabel.text = model.service_time;
    self.orderDetailView.orderTimeLabel.text = model.order_created_at;
    self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@", model.order_id];


    if ([status isEqualToString:@"1"]) {
        self.orderDetailView.typeLabel.text = @"待支付";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"2"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"3"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"4"]) {

        if ([swap_type isEqualToString:@"2"]) {

            self.orderDetailView.typeLabel.text = @"已发货";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];

        } else {

            self.orderDetailView.typeLabel.text = @"已服务";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
        }


    } else if ([status isEqualToString:@"5"]) {
        self.orderDetailView.typeLabel.text = @"已评价";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-1"]) {
        self.orderDetailView.typeLabel.text = @"已取消";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"-2"]) {
        self.orderDetailView.typeLabel.text = @"已申请退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-3"]) {
        self.orderDetailView.typeLabel.text = @"退款已受理";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-4"]) {
        self.orderDetailView.typeLabel.text = @"已退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-5"]) {
        self.orderDetailView.typeLabel.text = @"拒绝退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }


    [self.scroller addSubview:self.orderDetailView];


}

// 打电话
- (void)phoneAction:(UIButton *)sender {
    ODOrderDetailModel *model = self.dataArray[0];
    NSMutableDictionary *dic = model.user;

    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", dic[@"mobile"]];

    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];


}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
