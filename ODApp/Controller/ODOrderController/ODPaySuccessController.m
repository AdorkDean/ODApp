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

@interface ODPaySuccessController ()

@property (nonatomic , strong) ODPaySuccessView *paySuccessView;


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
            
            [self.paySuccessView.secondButton setBackgroundImage:[UIImage imageNamed:@"button_pay success_Order details_"] forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];

            
            
            
        }
        
        
        
    }
    return _paySuccessView;
}


- (void)cancelOrder:(UIButton *)sender
{
    
    
    
    
}



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

- (void)goOther:(UIButton *)sender
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
