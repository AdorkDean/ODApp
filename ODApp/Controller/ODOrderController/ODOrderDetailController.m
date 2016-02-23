//
//  ODOrderDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderDetailController.h"
#import "ODOrderDetailView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"
#import "ODCancelOrderView.h"
#import "ODDrawbackBuyerOneController.h"
#import "ODEvaluation.h"
@interface ODOrderDetailController ()< UITextViewDelegate>


@property (nonatomic , strong) ODOrderDetailView *orderDetailView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *delateManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *finishManager;
@property (nonatomic , strong) AFHTTPRequestOperationManager *evalueManager;


@property (nonatomic , strong) ODEvaluation *evaluationView;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic ,strong) ODCancelOrderView *cancelOrderView;

@property (nonatomic, copy) NSString *evaluateStar;
@property (nonatomic , strong) UIScrollView *scroller;

@end

@implementation ODOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.userInteractionEnabled = YES;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
    self.evaluateStar = @"1";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}


- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"order_id":self.order_id , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kOrderDetailUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                
                [self.dataArray removeAllObjects];
                NSMutableDictionary *dic = responseObject[@"result"];
                ODOrderDetailModel *model = [[ODOrderDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
                
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
            [weakSelf createScroller];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
    
}

- (void)createScroller
{
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    
    self.scroller.userInteractionEnabled = YES;
    self.scroller.backgroundColor = [UIColor whiteColor];
    
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    if ([status isEqualToString:@"-1"]) {
        
        
        self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 200);
        
        
    }else{
        
     
       self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 150);

        
            
        
    }
    
    
    [self.scroller addSubview:self.orderDetailView];
    
    
    [self.view addSubview:self.scroller];
    
    
    NSString *swap_type = [NSString stringWithFormat:@"%@" , model.swap_type];
    
    
    if ([status isEqualToString:@"3"]) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_Cancel order"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        refundButton.backgroundColor = [UIColor redColor];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];
        
        
        
    }else if ([status isEqualToString:@"2"]) {
        
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        refundButton.backgroundColor = [UIColor redColor];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];
        
        
        
        
        
    }
    
    
    
    
    else if ([status isEqualToString:@"1"]) {
        
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_Cancel order"] forState:UIControlStateNormal];
        
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
        payButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [payButton setBackgroundImage:[UIImage imageNamed:@"button_Pay immediately"] forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payButton];
        
        
        
        
    }else if ([status isEqualToString:@"4"]) {
        
        
        
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        refundButton.backgroundColor = [UIColor lightGrayColor];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];
        
        
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        confirmButton.backgroundColor = [UIColor redColor];
        
        
        if ([swap_type isEqualToString:@"2"]) {
            [confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
        }else {
            [confirmButton setTitle:@"确认服务" forState:UIControlStateNormal];
            
        }
        
        
        
        confirmButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmButton];
        
        
        
        
        
    }else if ([status isEqualToString:@"-5"]) {
        
        
        
        UIButton *reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        reasonButton.backgroundColor = [UIColor redColor];
        [reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        reasonButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reasonButton];
        
        
        
    }else if ([status isEqualToString:@"-3"]) {
        
        
        
        UIButton *reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        reasonButton.backgroundColor = [UIColor redColor];
        [reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        reasonButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reasonButton];
        
        
        
    }
    
    
    
    
    
    
}




// 查看原因
-(void)reasonAction:(UIButton *)sender
{
    
    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = self.orderDetailView.allPriceLabel.text;
    vc.order_id = self.order_id;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@" , model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    vc.refuseReason = model.reject_reason;
    vc.isRefuseReason = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
// 确认完成
-(void)confirmAction:(UIButton *)sender
{
    
    self.finishManager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"order_id":self.order_id , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.finishManager GET:kFinshOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                
                [self createEvaluation];
                
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
    
    
    
}


- (void)createEvaluation
{
    
    self.evaluationView = [[ODEvaluation alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.evaluationView.contentTextView.delegate = self;
    [self.evaluationView.cancelButton addTarget:self action:@selector(cancelEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.determineButton addTarget:self action:@selector(determineButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.evaluationView.firstButton addTarget:self action:@selector(firstButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.secondButton addTarget:self action:@selector(secondButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.thirdButton addTarget:self action:@selector(thirdButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.fourthButton addTarget:self action:@selector(fourthButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView.fiveButton addTarget:self action:@selector(fiveButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.evaluationView];
    
}

- (void)firstButtonClicik:(UIButton *)button
{
    
    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"1";
    self.evaluationView.titleLabel.text = @"非常不满意";
}

- (void)secondButtonClicik:(UIButton *)button
{
    
    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"2";
    self.evaluationView.titleLabel.text = @"不满意";
    
}

- (void)thirdButtonClicik:(UIButton *)button
{
    
    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"3";
    self.evaluationView.titleLabel.text = @"一般";
    
}

- (void)fourthButtonClicik:(UIButton *)button
{
    
    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
    self.evaluateStar = @"4";
    self.evaluationView.titleLabel.text = @"满意";
    
}

- (void)fiveButtonClicik:(UIButton *)button
{
    
    [self.evaluationView.firstButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.secondButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.thirdButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fourthButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    [self.evaluationView.fiveButton setImage:[UIImage imageNamed:@"3{1)]T1HQ%9R5HEQ$(3ZG0E"] forState:UIControlStateNormal];
    self.evaluateStar = @"5";
    self.evaluationView.titleLabel.text = @"非常满意";
    
}




- (void)determineButton:(UIButton *)sender
{
    
    
    
    self.evalueManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"order_id":self.order_id , @"reason":self.evaluationView.contentTextView.text, @"reason_num":self.evaluateStar , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    
    
    
    [self.evalueManager GET:kEvalueUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                [weakSelf.evaluationView removeFromSuperview];
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"评价成功"];
                
                
                
                if (weakSelf.getRefresh) {
                    
                    
                    
                    weakSelf.getRefresh(@"1");
                }
                
                
                
                
                
                [weakSelf getData];
                
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
    
    
    
    
    
    
}


// 评价
- (void)evaluationAction:(UIButton *)sender
{
    
    [self createEvaluation];
}

// 申请退款
- (void)refundAction:(UIButton *)sender
{
    
    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    
    vc.darwbackMoney = self.orderDetailView.allPriceLabel.text;
    vc.order_id = self.order_id;
    vc.isSelectReason = YES;
    vc.isRelease = YES;
    vc.confirmButtonContent = @"申请退款";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}




// 取消订单
- (void)cancelOrder:(UIButton *)sender
{
    self.cancelOrderView = [ODCancelOrderView getView];
    self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelOrderView.reasonTextView.delegate = self;
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.cancelOrderView];
    
}




#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    if (textView == self.cancelOrderView.reasonTextView) {
        if ([textView.text isEqualToString:@"请输入取消原因"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        
    }else if (textView == self.evaluationView.contentTextView) {
        
        if ([textView.text isEqualToString:@"请输入评价内容"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        
        
        
        
    }
    
    
    
}





-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    
    if (textView == self.cancelOrderView.reasonTextView) {
        if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {
            self.cancelOrderView.reasonTextView.text = @"请输入取消原因";
            self.cancelOrderView.reasonTextView.textColor = [UIColor lightGrayColor];
        }
        
    }else if (textView == self.evaluationView.contentTextView) {
        
        if ([self.evaluationView.contentTextView.text isEqualToString:@"请输入评价内容"] || [self.evaluationView.contentTextView.text isEqualToString:@""]) {
            self.evaluationView.contentTextView.text = @"请输入评价内容";
            self.evaluationView.contentTextView.textColor = [UIColor lightGrayColor];
        }
        
        
        
        
    }
    
    
    
    
    
    
    
}

- (void)submitAction:(UIButton *)sender
{
    
    
    
    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入取消原因"];
    }else{
        
        
        self.delateManager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"order_id":self.order_id , @"reason":self.cancelOrderView.reasonTextView.text, @"open_id":self.open_id};
        NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
        
        __weak typeof (self)weakSelf = self;
        [self.delateManager GET:kDelateOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject) {
                
                
                if ([responseObject[@"status"]isEqualToString:@"success"]) {
                    
                    [weakSelf.cancelOrderView removeFromSuperview];
                    
                    [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"取消订单成功"];
                    
                    
                    
                    if (weakSelf.getRefresh) {
                        
                        
                        
                        weakSelf.getRefresh(@"1");
                    }
                    
                    
                    [weakSelf getData];
                    
                    
                    
                }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                    
                    
                    [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                    
                    
                }
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        }];
        
        
        
        
        
        
    }
    
    
    
    
}


- (void)cancelEvaluation:(UIButton *)sender
{
    [self.evaluationView removeFromSuperview];
}


- (void)cancelView:(UIButton *)sender
{
    [self.cancelOrderView removeFromSuperview];
}



- (void)payAction:(UIButton *)sender
{
    ODPayController *vc = [[ODPayController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.orderId = [NSString stringWithFormat:@"%@" ,model.order_id];
    vc.OrderTitle = model.title;
    vc.price = [NSString stringWithFormat:@"%@" , model.price];
    vc.swap_type = [NSString stringWithFormat:@"%@" , model.swap_type];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (ODOrderDetailView *)orderDetailView
{
    if (_orderDetailView == nil) {
        self.orderDetailView = [ODOrderDetailView getView];
        
        self.orderDetailView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        ODOrderDetailModel *model = self.dataArray[0];
        NSMutableDictionary *userDic = model.user;
        NSMutableArray *arr = model.imgs_small;
        NSMutableDictionary *picDic = arr[0];
        
        
        
        NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
        
        
        if ([status isEqualToString:@"-1"]) {
            self.orderDetailView.spaceToTop.constant = 150;
            
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.orderDetailView.serviceTimeLabel.frame.origin.y + 30, kScreenSize.width, 6)];
            line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
            [self.orderDetailView addSubview:line];
            
            UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(18, line.frame.origin.y + 16, 100, 20)];
            reason.backgroundColor = [UIColor whiteColor];
            reason.font = [UIFont systemFontOfSize:14];
            reason.text = @"订单取消原因";
            reason.textAlignment = NSTextAlignmentLeft;
            [self.orderDetailView addSubview:reason];
            
            UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(18, reason.frame.origin.y + 30, kScreenSize.width - 18, 1)];
            secondLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
            [self.orderDetailView addSubview:secondLine];
            
            
            UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, secondLine.frame.origin.y + 11, kScreenSize.width - 36, 50)];
            reasonLabel.backgroundColor = [UIColor whiteColor];
            reasonLabel.font = [UIFont systemFontOfSize:14];
            reasonLabel.numberOfLines = 0;
            reasonLabel.text = model.reason;
            reasonLabel.textAlignment = NSTextAlignmentLeft;
            [self.orderDetailView addSubview:reasonLabel];
            
            
        }
        
        
        
        
        
        [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , userDic[@"avatar"]]] forState:UIControlStateNormal];
        [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , picDic[@"img_url"]]] forState:UIControlStateNormal];
        self.orderDetailView.nickLabel.text = userDic[@"nick"];
        self.orderDetailView.contentLabel.text = model.title;
        self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" ,model.price , model.unit];
        self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元" , model.price];
        self.orderDetailView.typeLabel.text = self.orderType;
        self.orderDetailView.addressNameLabel.text = model.name;
        self.orderDetailView.addressPhoneLabel.text = model.tel;
        
        NSString *swap_type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        if ([swap_type isEqualToString:@"2"]) {
            
            self.orderDetailView.serviceTimeLabel.text = model.address;
            self.orderDetailView.serviceTypeLabel.text = @"服务地址:";
            self.orderDetailView.swapTypeLabel.text = @"快递服务";
            
        }else{
            self.orderDetailView.serviceTimeLabel.text = model.service_time;
            self.orderDetailView.serviceTypeLabel.text = @"服务时间:";
            self.orderDetailView.swapTypeLabel.text = @"线上服务";
            
        }
        
        self.orderDetailView.orderTimeLabel.text = model.order_created_at;
        self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@" , model.order_id];
        
        
        
        
        
        if ([status isEqualToString:@"1"]) {
            self.orderDetailView.typeLabel.text = @"已下单未付款";
        }else if ([status isEqualToString:@"2"]) {
            self.orderDetailView.typeLabel.text = @"已付款未发货";
        }else if ([status isEqualToString:@"3"]) {
            self.orderDetailView.typeLabel.text = @"已付款";
        }else if ([status isEqualToString:@"4"]) {
            self.orderDetailView.typeLabel.text = @"已发货";
        }else if ([status isEqualToString:@"5"]) {
            self.orderDetailView.typeLabel.text = @"已评价";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
        }else if ([status isEqualToString:@"-1"]) {
            self.orderDetailView.typeLabel.text = @"已取消";
        }else if ([status isEqualToString:@"-2"]) {
            self.orderDetailView.typeLabel.text = @"买家已申请退款";
        }else if ([status isEqualToString:@"-3"]) {
            self.orderDetailView.typeLabel.text = @"退款已确认";
        }else if ([status isEqualToString:@"-4"]) {
            self.orderDetailView.typeLabel.text = @"已退款";
        }else if ([status isEqualToString:@"-5"]) {
            self.orderDetailView.typeLabel.text = @"拒绝退款";
        }
        
        
        
        
    }
    
    return _orderDetailView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
