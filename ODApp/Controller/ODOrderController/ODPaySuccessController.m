//
//  ODPaySuccessController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPaySuccessController.h"
#import "ODPaySuccessView.h"
#import "ODOrderDetailController.h"
#import "ODSecondOrderDetailController.h"
#import "ODBazaarViewController.h"
#import "ODCancelOrderView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODPaySuccessController ()<UITextViewDelegate>

@property (nonatomic , strong) ODPaySuccessView *paySuccessView;
@property (nonatomic , strong) ODCancelOrderView *cancelOrderView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *delateManager;
@property (nonatomic , copy) NSString *isCancel;

@end

@implementation ODPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.paySuccessView];

    
}


#pragma mark - 懒加载
- (ODPaySuccessView *)paySuccessView
{
    if (_paySuccessView == nil) {
              
        self.paySuccessView = [[ODPaySuccessView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        
        
        if ([self.payStatus isEqualToString:@"1"]) {
            
             self.paySuccessView.isSuccessLabel.text = @"您的订单已支付成功";
            self.paySuccessView.isSuccessView.image = [UIImage imageNamed:@"icon_background_"];
            
            
            [self.paySuccessView.firstButton setBackgroundImage:[UIImage imageNamed:@"button_pay success_Order details_"] forState:UIControlStateNormal];
            [self.paySuccessView.firstButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.paySuccessView.secondButton setBackgroundImage:[UIImage imageNamed:@"button_pay success_Go shopping again_"] forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(goOther:) forControlEvents:UIControlEventTouchUpInside];
            

        }else if ([self.payStatus isEqualToString:@"2"]) {
            
            
            
              self.paySuccessView.isSuccessLabel.text = @"对不起您的订单支付失败";
            self.paySuccessView.isSuccessView.image = [UIImage imageNamed:@"icon_Payment failure_background-1"];

            
            [self.paySuccessView.firstButton setBackgroundImage:[UIImage imageNamed:@"button_Payment failure_Cancel order_-1"] forState:UIControlStateNormal];
            [self.paySuccessView.firstButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.paySuccessView.secondButton setBackgroundImage:[UIImage imageNamed:@"button_Payment failure_Order details_"] forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];

            
            
            
        }
        
        
        
    }
    return _paySuccessView;
}


// 创建取消界面
- (void)cancelOrder:(UIButton *)sender
{
    
    if ([self.isCancel isEqualToString:@"1"]) {
           [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"订单已取消"];
    }else{
        self.cancelOrderView = [ODCancelOrderView getView];
        self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelOrderView.reasonTextView.delegate = self;
        [[[UIApplication sharedApplication]keyWindow] addSubview:self.cancelOrderView];

    }
    
    
    
}

// 取消评价界面
- (void)cancelView:(UIButton *)sender
{
    [self.cancelOrderView removeFromSuperview];
}


// 取消订单
- (void)submitAction:(UIButton *)sender
{
    
    
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    
    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入取消原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""]) {
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入取消原因"];
    }else{
        
        
        self.delateManager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"order_id":self.orderId , @"reason":self.cancelOrderView.reasonTextView.text, @"open_id":openId};
        NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
        
        __weak typeof (self)weakSelf = self;
        [self.delateManager GET:kDelateOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject) {
                
                
                if ([responseObject[@"status"]isEqualToString:@"success"]) {
                    
                    [weakSelf.cancelOrderView removeFromSuperview];
                    
                    [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"取消订单成功"];
                    
                    weakSelf.isCancel = @"1";
                    
                    
                    
                }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                    
                    
                    [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                    
                    
                }
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        }];
        
        
        
        
        
        
    }
    
    
    
    
}


// 订单详情
- (void)orderDetail:(UIButton *)sender
{
    
    
      
    if ([self.swap_type isEqualToString:@"1"]) {
        ODSecondOrderDetailController *vc = [[ODSecondOrderDetailController alloc] init];
        vc.order_id = [NSString stringWithFormat:@"%@" , self.orderId];
     
        [self.navigationController pushViewController:vc animated:YES];
             
    }else{
        
        
        ODOrderDetailController *vc = [[ODOrderDetailController alloc] init];
        vc.order_id = [NSString stringWithFormat:@"%@" , self.orderId];
        [self.navigationController pushViewController:vc animated:YES];
        
    
    }
    
    
}

// 再去逛逛
- (void)goOther:(UIButton *)sender
{
    
    self.tabBarController.selectedIndex = 2;
    ODBazaarViewController *vc = self.tabBarController.childViewControllers[2].childViewControllers[0];
    vc.index = 0;
    
      
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    if (textView == self.cancelOrderView.reasonTextView) {
        if ([textView.text isEqualToString:@"请输入取消原因"]) {
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
        
    }
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
