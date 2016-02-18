//
//  ODPayController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"
#import "ODPayView.h"
#import "ODPaySuccessController.h"
@interface ODPayController ()

@property (nonatomic , strong) UILabel *orderNameLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) ODPayView *payView;
@property (nonatomic , copy) NSString *payType;

@end

@implementation ODPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.payType = @"1";
    
    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.payView];
    
    
}

#pragma mark - 懒加载
- (ODPayView *)payView
{
    if (_payView == nil) {
        self.payView = [ODPayView getView];
        self.payView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        
        [self.payView.weixinPaybutton addTarget:self action:@selector(weixinPayAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [self.payView.treasurePayButton addTarget:self action:@selector(treasurePayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.payView.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return _payView;
}

- (void)payAction:(UIButton *)sender
{
    ODPaySuccessController *vc = [[ODPaySuccessController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


- (void)weixinPayAction:(UIButton *)sender
{
    
    self.payType = @"1";
    
    [self.payView.weixinPaybutton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
    
    [self.payView.treasurePayButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];

 
    
    
}

- (void)treasurePayAction:(UIButton *)sender
{
     self.payType = @"2";
    
    [self.payView.treasurePayButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];

    [self.payView.weixinPaybutton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
