//
//  ODPayController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"
#import "ODPayView.h"
@interface ODPayController ()

@property (nonatomic , strong) UILabel *orderNameLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) ODPayView *payView;

@end

@implementation ODPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.payView];
    
    
}

#pragma mark - 懒加载
- (ODPayView *)payView
{
    if (_payView == nil) {
        self.payView = [ODPayView getView];
        self.payView.frame = CGRectMake(0, 0, kScreenSize.width, 200);
        
    }
    return _payView;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
