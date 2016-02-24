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

            
            
            
            [self.paySuccessView.firstButton setTitle:@"再次支付" forState:UIControlStateNormal];
            self.paySuccessView.firstButton.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
            [self.paySuccessView.firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           self.paySuccessView.firstButton.layer.masksToBounds = YES;
           self.paySuccessView.firstButton.layer.cornerRadius = 5;
           self.paySuccessView.firstButton.layer.borderColor = [UIColor clearColor].CGColor;
           self.paySuccessView.firstButton.layer.borderWidth = 1;
            

            
            self.paySuccessView.firstButton.titleLabel.font = [UIFont systemFontOfSize:15];
            
            
            [self.paySuccessView.firstButton addTarget:self action:@selector(PayAgain:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.paySuccessView.secondButton setBackgroundImage:[UIImage imageNamed:@"button_Payment failure_Order details_"] forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];

            
            
            
        }
        
        
        
    }
    return _paySuccessView;
}


- (void)PayAgain:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
   

    
    ODBazaarViewController *vc = self.tabBarController.childViewControllers[2].childViewControllers[0];
    if (![self.navigationController.childViewControllers containsObject:vc])
    {
        [self.navigationController addChildViewController:vc];
    }
    
     NSLog(@"*******%@" , self.tabBarController.childViewControllers[2].childViewControllers);
    [self.navigationController popToViewController:vc animated:YES];
    vc.index = 0;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
